CREATE DATABASE IF NOT EXISTS notes_management
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE notes_management;

CREATE TABLE IF NOT EXISTS users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_username (username),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS notes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    user_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    KEY idx_notes_user_updated (user_id, updated_at),
    CONSTRAINT fk_notes_user FOREIGN KEY (user_id)
      REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS password_resets (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED NOT NULL,
    token_hash CHAR(64) NOT NULL,
    expires_at DATETIME NOT NULL,
    used_at DATETIME NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_password_resets_token_hash (token_hash),
    KEY idx_password_resets_user (user_id),
    KEY idx_password_resets_expiry (expires_at, used_at),
    CONSTRAINT fk_password_resets_user FOREIGN KEY (user_id)
      REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;
