
# README

# Assigment 2 

## Abstract

This project is an extension of a previous assignment which created a basic web
application modeling a school using the Ruby on Rails framework. This assignment
tests the hypothesis that large amounts of functionality can be added to the
application quickly because of the size of the Ruby on Rails community. This
hypothesis is tested by implementing new functionality through the use of free,
open-source plugins and libraries. The hypothesis was proven true by quickly
taking the app from a bare-bones app to a stylized application with search,
validation, and authentication features. 

## Introduction

Extending on the work of the first assignment, I am now going to expand the
application with additional functionality. The functionality will include,
adding search functions for each of the three entities already created, adding
an authentication layer, improving the user experience using CSS, and validating
data fields before they are committed to the database. My hypothesis for this
experiment is that because each of these features is so common, libraries have
been built specifically for the Ruby on Rails framework and can be implemented
with minimum custom development.

## Method/Measurement

Like the first assignment, the hypothesis will be tested in iterations. Each
iteration will focus on a single piece of the functionality. I will begin each
iteration by looking for libraries or plugins already built for the feature.
Once I choose one, it will be implemented following the best practices for the
library or tool. If the implementation of one feature breaks another feature,
the iteration will include time to fix the application, so all implemented
features are working at the end of each iteration. 

For the first iteration, I will implement authentication. Breaking from the
above method, I will implement Devise without searching for additional packages
because it was suggested by the customer (professor) for the product. 

Next, I will focus on adding search functionality. This will give a user the
ability to search for courses, professors, or sections. Courses and professors
will be searchable by name, and sections can be searched by either the professor
or the course name. 

After adding these two front-end features, I will turn to improving the user
experience by adding CSS to the website. This will also include modifying the
application layout to include basic navigation. 

Finally, I will add validation to the model to ensure all of the fields captured
in web forms are valid before committing them to the database. This will test
for both simple user import mistakes and test some basic business logic. 


## Results 

### Iteration 1: Authentication 

This iteration proved easier than expected. Normally, to implement an
authentication layer, a developer would have to design and develop the full
stack, but with Devise all it took was a couple of commands. First I added the
ruby gem for Devise to my gems file then ran a bundle install. Devise requires a
root path to be defined, so I added a path to professors.

```ruby
root to: "professors#index"
```


Then I added the authentication action to each controller that I expect to hold
protected content. 

```ruby
before_action :set_course, only: [:show, :edit, :update, :destroy]
```
Adding this automatically redirected the user to a sign-in/signup page

![Basic Login](/README_IMAGES/basic_login.jpg?raw=true)

Next I added a quick logout button to the layout file so that I could test the
full default function of Devise. 

```diff
-  <body class="<%= controller.controller_name %>">
-    <%= yield %>
-  </body>
+    <body class="<%= controller.controller_name %>">
+        <div id="banner"> 
+            <% if(user_signed_in?) %> 
+                <%= link_to 'Log out', destroy_user_session_path, method: :delete %>
+            <% end %>
+        </div>
+        <%= yield %>
+    </body>
```

 With this work complete, I moved on to the next iteration.

### Iteration 2: Search

I did not expect search to be arduous to add, and a quick search online for
search methods confirmed this theory. It looked like most people implemented
their own search functions in the controller rather than using a gem or other
library. I decided to dive right in and try to see how much code it would take
to add search to professors. 

First, I wrote the method in the controller. I wanted it to be able to return
either JSON or HTML for static or dynamic searching. In less than 20 minutes I
had come up with this:

```ruby
  def search
    searchString = params[:search];
    if(searchString.nil? || searchString.length < 3) 
      @professors = []
    else 
      @professors = Professor.where("name like (?)", "%#{searchString}%").limit(5)
    end 
    respond_to do |format|
      format.json { render json: @professors }
      format.html { render :index}
    end
  end
```

I decided to only show results if more than three characters are in the search
string. I will probably change this later. I took advantage of the fact that the
index page already had JSON and HTML views and all I had to do was set the same
@professors variable for them to use, then call render. 

I then added a route to routes.rb for the search path.

```diff
-  resources :professors
+  resources :professors do
+    collection do
+      get "search"
+    end 
+  end
```

I was immediately able to test the routes using JSON by visiting
http://localhost:3000/professors/search.json?search=test. To finish off the
feature, I added a quick search box to the professor index view using the rails
form helpers.

```ruby
<%= form_tag search_professors_path, method: :get do %> 
    <%= text_field_tag :search %>
    <%= submit_tag 'Search' %>
<% end %>
```

![Basic Search](/README_IMAGES/basic_search.jpg?raw=true)

I used very similar code for the courses and sections controllers with the
sections controller a bit modified to support searching courses from two
different tables. 

```ruby
  def search
    searchString = params[:search];
    @sections = [] 
    unless(searchString.nil? || searchString.length < 3) 
      professors = Professor.where("name like (?)", "%#{searchString}%")
      courses = Course.where("name like (?)", "%#{searchString}%")
      professors.each do |professor| 
        @sections.push(professor.sections)
      end 
      courses.each do |course|
        @sections.push(course.sections)
      end
      @sections.flatten!
      @sections.uniq!
      
    end 
    respond_to do |format|
      format.json { render json: @sections }
      format.html { render :index}
    end
  end
```

### Iteration 3: CSS

To get the site looking professional as quickly as possible, I turned to
Bootstrap. I installed the Bootstrap library using a gem and included it in my
application.scss and application.js files. From there, I began modifying all of
the views to use the bootstrap classes to apply the bootstrap CSS to them. I
modified the application.html.erb file in the layouts folder heavily to get the
desired look. I ended up adding a header with a navigation bar including Sign
Out and Edit Profile buttons if you are logged in and a Sign-In and Sign Up
button if you are logged out. I also added a search bar in the far right of this
top nav bar and removed the previously created search bars. Finally, I added a
navigation partial for the three entities and added it as a side navigation bar.
There are too many changes to cohesively summarize here as I spent 5-6 hours in
this iteration. The results should speak for themselves. Below is the professors
view before and after. 

![Professors Before](/README_IMAGES/professors_before.jpg?raw=true)
![Professors After](/README_IMAGES/professors_after.jpg?raw=true)

And the new page is responsive.

![Responsive Professors](/README_IMAGES/professors_responsive.jpg?raw=true)

The only code I will include here is the totality of the CSS I wrote. 

```css
@import “bootstrap”;

#content {
    padding: 15px !important;
}
```

### Iteration 4

The fourth iteration was the quickest iteration. I was able to add validation
for all fields in the database quickly. I did not add any additional validation
to the tables created by Devise because they are already vetted before
insertion. First I added validation to the Professors model:

```ruby
  validates :name, :department,  presence: true
  validates :name, length: { minimum: 3 }
  validates :department, length: { minimum: 3 }
 
  validates :department, format: { with: /\A[a-z A-Z]+\z/ }

  #only one professor with the same name in the department
  validates :name, uniqueness: { scope: :department }
```

The validations are pretty much self-explanatory and easy to read. The most
difficult one may be the regex which validates to make sure the department only
contains a-Z and spaces.

The courses validation is so similar that it does not warrant mention here.
Below are a couple of the validations that I added to the sections controller
which allows it to validate unique conditions across multiple columns in the
database. Some of the same columns are used in more than one unique validation.

```ruby
  #a professor cannot teach two classes at the same time
  validates :professor, uniqueness: { scope: [:time, :semester] }

  #the class cannot be taught in the same classroom at the same time 
  validates :classroom, uniqueness: { scope: [:time, :semester] }
```

## Conclusion

Ruby on Rails has an extensive user base with a large library of custom code
modules. For this assignment, I was able to leverage this community to add
functionality to the application quickly. The level of sophistication added to
the application by using these base libraries and plugins would not be possible
with traditional custom development. Some pieces did not require libraries
because of how simple they were to add with custom code. Validation and
searching were both added to the application with only a few dozen lines of code
each. Devise added an entire authentication framework with only a few commands,
and bootstrap allowed the entire application to be stylized by adding classes to
mostly existing elements and with practically no plain CSS. This proved the
hypothesis that significant features can be added with minimal development
because of the large Ruby on Rails community. 

# Appendix A: Things to Add
1.    Semesters Table
2.    Departments Table
  1.    Link Professors and Courses to Departments
  2.    Update controllers and views such that Courses can only be taught by professors of the same department. 
5.    Home page
7.    Sections Links to Professor and Course
8.    Course links instead of “show”
9.    Button for course “Add” 

### Author
* Alan Peters

