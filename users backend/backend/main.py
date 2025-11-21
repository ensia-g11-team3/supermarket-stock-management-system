from fastapi import FastAPI, HTTPException
from database import init_db, get_connection
from models import User, UserUpdate, LoginModel, UserState
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# CREATE DB ON START
init_db()

# Allow requests from Flutter app (desktop or web)
origins = [
    "http://localhost",
    "http://127.0.0.1",
    "http://localhost:5173",  # Flutter web dev server
    "*",  # For testing, allow all origins
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/login")
def login(data: LoginModel):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM users WHERE username = ?", (data.username,))
    user = cursor.fetchone()

    if not user or user["password"] != data.password:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    return {"message": "Login success"}


@app.post("/users")
def add_user(user: User):
    conn = get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            """
            INSERT INTO users (username, full_name, email, phone, role, is_active, created_at, password)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                user.username,
                user.full_name,
                user.email,
                user.phone,
                user.role,
                int(user.is_active),
                user.created_at,
                user.password,
            ),
        )
        conn.commit()
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

    return {"message": "User added"}


@app.get("/users")
def get_users():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM users")
    rows = cursor.fetchall()

    return [dict(row) for row in rows]


@app.put("/users/{user_id}")
def update_user(user_id: int, data: UserUpdate):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        """
        UPDATE users SET username=?, full_name=?, email=?, phone=?, role=?, password=?
        WHERE id=?
        """,
        (
            data.username,
            data.full_name,
            data.email,
            data.phone,
            data.role,
            data.password,
            user_id,
        ),
    )

    conn.commit()

    return {"message": "User updated"}


@app.patch("/users/{user_id}/state")
def set_state(user_id: int, state: UserState):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(
        "UPDATE users SET is_active = ? WHERE id = ?",
        (int(state.is_active), user_id),
    )
    conn.commit()

    return {"message": "State updated"}


@app.delete("/users/{user_id}")
def delete_user(user_id: int):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM users WHERE id = ?", (user_id,))
    conn.commit()

    return {"message": "User deleted"}
