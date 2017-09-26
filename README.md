# README

## Abstract

This project is designed to test a hypothesis about the Ruby on Rails framework.
The hypothesis is that because Ruby on Rails provides a tested and common web
framework, applications can be developed quickly and modified in iterations
without needing exhaustive design sessions since the architecture is well
defined. This project evaluates the hypothesis by capturing the development
process of a Ruby on Rails applications as it goes from simple requirements and
design to a functioning web application. This project, by successfully creating
a simple working application through iterative development, proved the
hypothesis.

## Introduction

Ruby on Rails gives the developer a framework to quickly create websites using
the Ruby language. One of the tools the framework provides is a set of
generators which allows a developer to create a   scaffolding for the code from
the command line. The generated code fits into the MVC architecture using the
Rails nomenclature and structure. I hypothesize that because Ruby on Rails
provides a tested and proven web framework, applications can be developed
quickly and modified in iterations without needing exhaustive design sessions
since the architecture is well defined. 

## Method/Measurement

To test this hypothesis, I have broken the development of the application into
phases. Each phase has minimal deliverables and is designed to be implemented
rapidly before beginning the next sections. Each iteration described below,
except for the first, was driven off of requirements and lessons learned from
the previous phase. 

The first iteration is a rapid design and setup session. This iteration includes
setting up the basic project, creating a simple entity relationship diagram
(ERD) for the model, and sketching out some rough screenshots or wireframes.

The second iteration will include using rails to set up the scaffolding for the
initial application based off of the simple ERD. Then making modifications to
the views so that I can enter data for all entities created in the database.

The next iteration will focus on modifying views and controllers to conform to
the quick sketches of the screens for the application.

Along the way, I will list potential improvements and ideas (Appendix C). I will make any
necessary design changes during the iteration. If time allows, I will plan and
execute additional iterations to incorporate left-over enhancements. 

I will maintain a list of the commands and instructions used to create this
application and include it in an appendix (Appendix A). Git version control will be used to
manage the code base during development. 

## Results

### Iteration 1:

The first iteration was time-boxed to two quick 25-minute work sections with a
five-minute break in between. In this time, I sketched out a quick ERD and
screenshots (Appendix B) for each entity. I annotated these screenshots
during the second iteration. At the end of the second session, I ran the first
five commands to set up a new Rails project and add the generated code to an
empty git repository. It turned out that the ‘git init’ command was unnecessary
because the rails new command created an empty git repository. I used Agile Web
Development with Rails 5 [1] to come up with the commands for this iteration.

### Iteration 2:

I dove into coding with Iteration two. I used the first 25-minute session to
start the server and make sure rails was running, then added the first scaffold
for Professors. Professors’ only attributes are a name and a department, both
strings. I committed the code changes before running the migration, and after
running the migration, I found rails had created additional files which I needed
to add to Git. I committed these new files with a temporary message then
performed an interactive rebase to squash them into the previous commit. I then
created a couple of test Professor entries and tried updating, and deleting them
to see if all of the scaffolding worked correctly. I then added the courses and
the section scaffolds with quick commits in between to capture the state after
each migration. 

I used the next session to update the new section view to add a select list for
both Professors and Courses. 

```ruby
<%= form.select :professor_id, @professors.collect { |p| [p.name, p.id] }, include_blank: true %>
<%= form.select :course_id, Course.all.collect { |c| [ c.name, c.id]},  include_blank: true   %>
```

I tested the view and controllers by adding several Sections and reviewing them
in the Sections list. After this simple testing was complete, I added new fields
to the Section entity. I had included these fields in the original design but
overlooked them when I created the scaffold with the generator. I added these
fields using the Rails migrate command then updating the view templates for the
Section form and Section show pages. I modified the Sections controller to add
time, classroom, and semester fields to the params.require statement. 

```ruby
def section_params
    params.require(:section).permit(:professor_id, :course_id, :semester, :classroom, :time)
end
```
I created additional sections to verify all the fields were captured and
displayed correctly.

### Iteration 3:

In iteration three, I focused on the display of the entities. The most difficult
part of this iteration was building the hierarchy views for both the Professors
view and the Courses view. I found this difficult because it required the
natural hierarchy to be reversed. For Professors, the hierarchy to get to
courses is Professor -> Section -> Course. The view required Professor -> Course
-> Section. First, I added a relation to the Professor model which specifies
that the Professor has many courses through Sections, I added a similar route to
Courses. 

```ruby
class Course < ApplicationRecord
    has_many :sections
    has_many :professors, through: :sections
end

class Professor < ApplicationRecord
    has_many :sections
    has_many :courses, through: :sections
end
```

Then I could enumerate the Professor’s distinct Courses using
professor.courses.uniq. Then I iterated over this enumeration in the view to get
each course. For each Course, I created a sub-list of all the sections using
course.sections. This results in ruby printing sections for the courses which
are not related to the original professor. I did a quick-fix to update the list
by modifying the view to check if section.professor equaled the current
Professor and only then printed the list item. 

```ruby 
    <% @courses.each do |course| %>
          <li><%= course.name %></li>
          <li><%= link_to course.name, course %></li>
          <ul>
              <% course.sections.each do |section| %>
                  <% if section.professor === @professor %>
                  <li>
                  <%= link_to section.time.strftime("%l:%M %p"), section
                  %></li>
                  <% end %>
              <% end %>
          </ul>
      <% end %>
  </ul>
```

After I swapped to the courses view to make the same update, I had a nagging
feeling that this would require up to n^2 calls to the database by going from
Professors to Sections to Courses then back to Sections and Professors. And it
would retrieve objects that would never be displayed. This is a case of
pre-optimization, but I revisited the code to see if I could create the list
with fewer calls to the persistence layer. The resulting code used a combination
of a hash and arrays built from the list of the Professor’s Sections. This hash
is passed to the view and the number of calls to the database becomes closer to
n where n is the number of Sections a Professor is teaching.

```ruby
   def show
    @profs_courses = {};
    sections = @professor.sections

    sections.each do |section| 
      if @profs_courses[section.course].nil?
        @profs_courses[section.course] = [];
      end
      @profs_courses[section.course].push section

    end
  end
```
```diff
<h3>Courses</h3>
 <ul>
-    <% @courses.each do |course| %>
+    <% @profs_courses.each do |course,sections| %>
         <li><%= link_to course.name, course %></li>
         <ul>
-            <% course.sections.each do |section| %>
-                <% if section.professor === @professor %>
+            <% sections.each do |section| %>
                 <li>
-                <%= link_to section.time.strftime("%l:%M %p"), section
-                %></li>
-                <% end %>
+                    <%= link_to section.time.strftime("%l:%M %p"), section
+                    %></li>
             <% end %>
         </ul>
     <% end %>
 </ul>
```

As a small change to the design, I decided to display the time for each Section
in the Professor and course views. When I tested these new views, an error arose
because not all Sections had a time in the database. In order to remedy this for
future additions, I added a validation for the presence of the time field to the
model. To fix current entries in the test database, I used the command qlite3
db/development.sqlite3 to enter into the database. Then I ran: UPDATE sections
SET time = ‘2000-01-01 00:00:00’ WHERE time IS NULL; to update all of the
currently null time entries to 12:00 am. Rails stores time fields in a date
column and defaults the date part to 1/1/2000. 



The last work I did as part of this iteration was to refactor the sections
controller code slightly to make it more DRY. I had created the calls to set the
@courses and @professors variables in each method making them less flexible if I
needed to change them. Now I removed them and put them in a new method. I
registered this new method with a :before_action which Rails calls before
running the new, create, update, and edit methods. I was prompted to make this
change because of an issue where I was expecting render() to call the route
controller, but instead, it only calls the views and requires all of the proper
variables to be already set. 

```ruby
before_action :set_course_professor_list, only: [:new, :edit, :update, :create]
...

...
def set_course_professor_list 
    @courses = Course.all 
    @professors = Professor.all
end
```

## Conclusion

Ruby on Rails had already made most of the architecture choices for me which
allowed me to develop the site and make design changes rapidly. In traditional
development, architectural choices set the foundation for the rest of
development and a change to the architecture may require significant amounts of
time to correct. This potential loss of time requires lots of effort to be spent
on solidifying an architecture before moving on to other aspects of coding. With
Rails, I was confident that the architecture is thoroughly tested and proved and
I was able to jump right into coding the application with minimal design.
Because I followed a strict MVC pattern, I could change pieces of the
application without sending ripples through the entire application. 

I tested this methodology by building the application in short iterations with
minimal planning. When I found new requirements, I was able to incorporate them
directly into the code without extensive design. Rails provided all but the
highest-level functions, so I did not have to worry about building objects with
persistence or their relationships. The scaffolds created by running ruby
commands allowed me to customize the code to get the desired look rather than
starting with a blank canvas. This mentality helped reduce some of the fear
associated with starting a new file and provided immediate feedback on the
changes made. This exercise proved my hypothesis that applications can be
developed quickly and modified in iterations without needing exhaustive design
sessions since the architecture is well defined. 



## Sources

1. Ruby, Sam. Agile Web Development with Rails 5 (Kindle Location 2154). Pragmatic Bookshelf. Kindle Edition.
2. www.w3schools.com
3. api.rubyonrails.org/.
4. ruby-doc.org
5. https://stackoverflow.com/a/10189374
6. https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet



## Feedback for the Instructor

This assignment was very informative because it forced me to develop an
application in Ruby on Rails. I liked how loosely the requirements were defined
because it allows a bit of latitude to explore the architecture and add custom
pieces.

I think the hardest part of the assignment was trying to parallel the paper and
the code development. Especially early on in a project with a single developer,
it is easy to jump around and make lots of disconnected changes to a code base
and throw away changes or redo sections before committing code. This process is
relatively fluid, and I found it difficult to map it to a linear progression
through the paper. If I were to write an instruction book on how to put this
application together, I would have to redo the entire application and probably
do one or two more iterations before getting it to settle into a linear set of
instructions. Also, the paper took about as much time as the assignment. Once I
wrote a section of the paper, I did not want to make any more changes to the
code because it would require the paper to change as well. I think a different
type of documentation would be helpful.

I also believe that with a different kind of documentation, you could shorten
the assignment duration to one week and then you could assign several shorter
iterations of the application. You could even crowdsource changes to the
application through peer-review sessions at the end of each assignment.

I learned a lot more about letting go to my code and not understanding the
entirety of the architecture. I learned through doing. I had gone through about
50% of the example application in the Ruby on Rails book but not having a one to
one guide for an assignment helped push me into uncharted waters where I made
errors and had to search for answers and documentation. It was like a test where
I found out everything I did not know. I am looking forward to the next
iteration.

# Appendix A: Commands

1.    rails new School
2.    cd school
3.    git init #already initialized
4.    git add .
5.    git commit -m "Initial Commit"
6.    rails server
7.    rails generate scaffold professor name:string department:string 
8.    git add .
9.    git commit -m "Adding professor scaffold"
10.    bin/rails db:migrate
11.    git commit –m fixup
12.    git rebase –i HEAD~2
13.    bin/rails generate scaffold course name:string description:text department:string
14.    git commit –am “Adding course scaffold”
15.    bin/rails generate scaffold Section professor:belongs_to course:belongs_to
16.    git commit –am “Adding Sections Scaffold”
17.    git commit -am "Updating the Sections Views"
18.    git commit -am "Updating the professors view"
19.    git commit -am adding courses to view professor
20.    bin/rails generate migration AddTimeColumnsToSection time:time semester:string
21.    bin/rails generate migration AddClassroomToSection classroom:string
22.    bin/rails db:migrate
23.    git commit -am "adding columns to section. Modifying professor and course
       views"
24.    sqlite3 db/development.sqlite3
25.    UPDATE sections SET time = ‘2000-01-01 00:00:00’ WHERE time IS NULL;
26.    .quit –exit sqlite3
27.    git commit -am "Updating controller for sessions"

# Appendix B: Design and ERD

![Design and ERD](/README_IMAGES/ERD_And_Design_1.jpg?raw=true)
![Design and ERD](/README_IMAGES/Design_2.jpg?raw=true)


# Appendix C: Things to Add
1.    Semesters Table
2.    Departments Table
  1.    Link Professors and Courses to Departments
  2.    Update controllers and views such that Courses can only be taught by professors of the same department. 
3.    Header
4.    Left Menu
5.    Home page
6.    Updated Styles
7.    Sections Links to Professor and Course
8.    Course links instead of “show”
9.    Button for course “Add” 

### Author
* Alan Peters





# Assigment 2 

##Log
* Added devise to gem file
* $bundle install
* Add root to: "professors#index" to routes.rb
* $rails generate devise User
* $rails db:migrate
* Add before_action: authenticate_user! to professor controller 
* Reboot server
* 
* $rails generate devise:views
* Add authenticate to sessions and courses controllers
* Add logout to layout
*
* Added search route for professors
* Added search controller
* Added search textbox to view
*
* Added search functionality for courses
* 


## Sources
1. https://github.com/plataformatec/devise
2. 









