# README



###Assignment One

##Abstract


##Introduction

The problem I am looking to investigate is the amount of time it takes to create
a basic full-stack web longer application in Ruby on Rails. My hypothisis is
that a full working app can be setup in as little as little as 20 hours
including design of the application. 

##Method/Measurement

The method to develop this application is broken up into iterations. The first
iteration is a very quick design and setup session. This includes setting up the basic
project, creating a simple ERD for the model, and sketching out some rough
screenshots or wireframes.

The second iteration will include using rails to setup the scaffolding for

All time spent on the project will be logged below, along with a list of
commands and instructions on creating the application. 

##Results

##Conclusion




#Time Log

| Pomodoro # | Description                                   |
| -----      | ----                                          |
| 1          | Setup basic project, began README.            |
| 2          | Basic ERD and Design Sketched out in notebook |
| 3          | Finished design, added professor scaffold     |


#Commands

1. rails new School
2. cd school
3. git init #already initialized
4. git add .
5. git commit -m "Initial Commit"
6. 
7. rails server
8. rails generate scaffold professor name:string department:string 
9. git add .
10. git commit -m "Adding professor scaffold"
11. bin/rails db:migrate
12.
13. bin/rails generate scaffold course name:string description:text
    department:string
