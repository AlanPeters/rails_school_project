class SectionsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_section, only: [:show, :edit, :update, :destroy]
  before_action :set_course_professor_list, only: [:new, :edit, :update, :create]
  # GET /sections
  # GET /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(section_params)

    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to @section, notice: 'Section was successfully updated.' }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

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
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_section
    @section = Section.find(params[:id])
  end

  def set_course_professor_list 
    @courses = Course.all 
    @professors = Professor.all
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def section_params
    params.require(:section).permit(:professor_id, :course_id, :semester, :classroom, :time)
  end
end
