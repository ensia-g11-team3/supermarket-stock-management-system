from pydantic import BaseModel

class User(BaseModel):
    username: str
    full_name: str
    email: str
    phone: str
    role: str
    is_active: bool
    created_at: str
    password: str

class UserUpdate(BaseModel):
    username: str
    full_name: str
    email: str
    phone: str
    role: str
    password: str

class UserState(BaseModel):
    is_active: bool

class LoginModel(BaseModel):
    username: str
    password: str
