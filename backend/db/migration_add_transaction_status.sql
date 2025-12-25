-- Add status column to transactions table
-- This migration adds support for transaction returns

ALTER TABLE transactions 
ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'completed' 
COMMENT 'Transaction status: completed, returned' 
AFTER payment_method;

-- Update existing transactions to have 'completed' status
UPDATE transactions SET status = 'completed' WHERE status IS NULL OR status = '';
