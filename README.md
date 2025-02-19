Ruby version: 3.2.0

Rails version: 8.0.1

rails new user_task_management --api

rails g model User name email password_digest phone status:integer

rails g model Task title description:text status:integer due_date:datetime user:references

rails generate serializer User

rails generate serializer Task
