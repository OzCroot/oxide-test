-- Active users only
SELECT id, name, email
FROM users
WHERE active = 1; -- soft-deleted rows are excluded
