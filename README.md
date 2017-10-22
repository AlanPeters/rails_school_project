# README

# Assignment 3

## Abstract

This third and final assignment builds on the work of the previous two
assignments to further test the Ruby on Rails ecosystem. This assignment tests
the hypothesis that new models can be added to the existing object model, and
can be semantically related to each other using routing. This hypothesis is
ultimately proven true with the caveat that, although the functionality is in
place, the documentation for first-time developers made finding and
understanding the documentation more difficult than needed. This was both
because of the format of official documentation, and the nature of a large and
fractured ecosystem with multiple versions of Ruby on Rails still in use. 

## Introduction

Using the first and second assignments as a base for this third and final
assignment, I will add a new set of models to represent students, and allow the
students to enroll in sections. The enrollments will be purely a ‘join’ table
used to relate students to courses and will not hold any additional relevant
information other than the primary keys for the student and the section. All of
the enrolled sections will be listed on the student ‘show’ page. I will extend
the listing of sections on the professor ‘show’ page to now have a third tier
showing all of the students registered for that section. I will only show the
new enrollments and enrollments index pages in the context of a single student.
I will accomplish this by embedding parts of the enrollment resource in the
student routes. 

I am working on this assignment with the hypothesis that the Ruby on Rails
Framework is designed to easily add new models and add their relationships to
existing objects. Further, I am testing that I can model a has-a relationship
through routing to show the relationship to a user through the URL. 

## Method/Measurement

I will continue to practice iterative development as I did in the first two
parts of this project. I am continuing to use iterative development both because
I want to maintain consistency between these experiments, and also because the
method has been extremely effective in developing this application. 

I will use the first iteration to dive right into the model development. The
goal will be to have a student object that I can populate with some data through
the front end and have the enrollment object setup such that a student is
related to sections, and by extension, professors and courses. I will also set
up the routing for enrollments to show that students have enrollments. 

Then the second iteration will be used for creating an enrollment process. The
concept is to have a table of sections and an enroll button or link on each row
that the student can press to sign up for the class. On the enrollments page,
the student will have the option to drop any class they have enrolled. 

The third iteration will add the required display functionality. I will extend
the hierarchy for professors to show their courses, sections, then students.
Also, I will add a course listing for the student show page that shows all of
the sections that the student is currently enrolled. 

## Results 

### Iteration 1: Modeling

Adding the students object and enrollments join table were both extremely easy,
at this point I was in very familiar territory. 

```bash
rails generate scaffold student name:string status:boolean 
rails generate scaffold enrollment student:reference section:reference
```

After that, I setup the routing I wanted for the enrollments. I decided to only
embed some of the routes based on advice from Rails Routing from the Outside In
(http://guides.rubyonrails.org/routing.html).

```ruby
  resources :students do
    resources :enrollments, only: [:index, :new, :create]
  end

  resources :enrollments, only: [:update, :destroy]
```

I immediately began running into some issues with errors in the enrollments and
student views because of this change, but decided that I had reached the goals
of Iteration One and pushed these issues into the next iteration. 

### Iteration 2: Enrollments

I spent a lot more time in this iteration than expected. The errors I
encountered in the previous example took longer to solve than I had hoped. The
issues required a pretty minor change, I had to update some of the enrollment
paths to include ‘students’ and pass a student object. 

```diff
+student_enrollments_path @student
-enrollments_path
```
The hardest part to fix was the forms for creating an enrollment. This was a
pretty common issue for beginning rails developers but most of the top results
were for versions of rails before 5.0. Most of the results used the ‘form_for’
or ‘form_tag’ helpers, which are both being deprecated, instead of the new
‘form_with’ tag. After spending a a couple hours trying out different options, I
finally realized I could just change my original form_with tag slightly to get
the correct result.

```diff
-<%= form_with model: @enrollment do |form| %>
+<%= form_with model: [@student, @enrollment] do |form|
```
this simple change took hours to find in the documentation and was the result of
adapting answers using form_for with documentation on form_with. 

Also during this iteration, I found that I had to adapt another part of the
design. Originally I had wanted a student to see a table of all available
sections and be able to click a button on a given row to enroll in that course.
Unfortunately, you cannot embed a form inside of a table. In order to get the
functionality I desired, I would have to turn to javascript to populate and
submit ahidden form depending on what button was pressed. I decided to
re-evaluate my design. What I came up with I decided was ultimately a better
solution. I created a list of courses with all of the available sections listed
under each course header. I was able to embed my form using the simple rails
helper ‘button_to’ with some hidden fields representing the student and section
IDs. 

![New Student Enrollments](/README_IMAGES/student_enrollments.jpg?raw=true)

With the enrollment functionality finally working, I moved on to the final
iteration. 

### Iteration 3: Display

I used this final iteration to put all of the finishing touches on the app. I
started by deleting out the edit, and show options for enrollments in the
routes. I decided that there was no value gained by viewing an individual
enrollment at this time, although I left the controllers and views intact in
case we later want to add grades or other info related to that specific
relationship. I updated the enrollments index to reflect this new routing by
only giving a ‘Drop’ opetion for current enrollments. 

![Student Enrollments](/README_IMAGES/student_enrollments_list.jpg?raw=true)
![Drop Enrollment](/README_IMAGES/drop_enrollment.jpg?raw=true)

Now that the enrollment process was working all the way through, I added
functionality to show the enrollments on the students page. 

![Show Student](/README_IMAGES/show_student.jpg?raw=true)

Then I updated my professors view to show the student in each course. 

![Show Student](/README_IMAGES/show_student.jpg?raw=true)

The last thing that I did was update the controller for the new enrollments
view. I wanted to only show sections that the student was not currently enrolled
in. It turns out, this was extremely easy using the array arithmetic function
‘-‘.

```ruby
@sections = Section.all - @student.sections
```

## Conclusion

Ruby on Rails makes adding new models easy using the same generate commands used
to set up the project initially. In this project, however, the extent of the
user base, and the number of different versions of Ruby on Rails still found in
production applications made finding the answer to some simple questions more
difficult than needed. Part of this is Google, and Stack Overflow’s tendency to
link to the most cited answers, which for the most part, meant Ruby 4.0.
Ultimately, implementing embedded routes was a trivial task, but finding the
documentation on how to do this was not. Some of the answers were embedded in
long pages of documentation covering large pieces of functionality and designed
to be read in their entirety. Ruby on Rails has ‘magic, to do just about
everything, sometimes it is just difficult to figure out how to use it the first
time. 

# Appendix A: Things to Add
1.    Semesters Table
2.    Departments Table
  1.    Link Professors and Courses to Departments
  2.    Update controllers and views such that Courses can only be taught by professors of the same department. 
5.    Home page
7.    Sections Links to Professor and Course
8.    Course links instead of “show”
9.    Button for course “Add” 
10.   Relationship between devise users and students or professors
11.   Auth-Z

### Author
* Alan Peters
