# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Schema
users
- id (primary key)
- name
- created_at
- updated_at

sleep_records
- id (primary key)
- user_id (foreign key to users.id)
- clock_in (timestamp)
- clock_out (timestamp)
- duration (integer, in minutes)
- created_at
- updated_at

follows
- id (primary key)
- follower_id (foreign key to users.id)
- followee_id (foreign key to users.id)
- created_at
- updated_at

