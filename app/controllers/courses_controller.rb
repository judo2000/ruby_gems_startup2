class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :show ]
  before_action :set_course, only: [ :show, :edit, :update, :destroy, :approve, :unapprove, :analytics ]

  def index
    # if params[:title]
    #   @courses = Course.where('title LIKE ?', "%#{params[:title]}%") #case sensetive
    # else
      #@courses = Course.all

      # @q = Course.ransack(params[:q])
      # @courses = @q.result.includes(:user)
    # end

    @ransack_path = courses_path

    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
     #@courses = @ransack_courses.result.includes(:user)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :course_tags => :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
  end

  def purchased 
    @ransack_path = purchased_courses_path
    @ransack_courses = Course.joins(:enrollments).where(enrollments: {user: current_user}).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :course_tags => :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    render 'index'
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where(user: current_user)).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    render 'index'
  end

  def created
    @ransack_path = created_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    render 'index'
  end

  def unapproved 
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.unapproved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :course_tags, :course_tags => :tag))
    @tags = Tag.all.where.not(course_tags_count: 0).order(course_tags_count: :desc)
    render 'index'
  end

  def approve 
    authorize @course, :approve?
    @course.update_attribute(:approved, true)
    redirect_to @course, notice: "Course approved!"
  end

  def unapprove
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to @course, notice: "Course unapproved and hidden!"
  end
  
  def analytics
    authorize @course, :owner?
  end

  def show
    authorize @course
    @lessons = @course.lessons.rank(:row_order)
    @enrollments_with_reviews = @course.enrollments.reviewed
  end

  def new
    @course = Course.new
    authorize @course
    @tags = Tag.all
  end

  def edit
    authorize @course
    @tags = Tag.all
  end

  def create
    @course = Course.new(course_params)
    authorize @course
    @course.description = 'Curriculum description'
    @course.marketing_description = 'Marketing description'
    @course.user = current_user
    respond_to do |format|
      if @course.save
        format.html { redirect_to course_course_wizard_index_path(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        @tags = Tag.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        @tags = Tag.all
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @course
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
        format.json { head :no_content }
      end
    else 
      redirect_to @course, alert: "This course has enrollments and cannot be destroyed."
    end
  end

  private
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :description, :marketing_description, :price, 
        :language, :level, :published, :logo, tag_ids: [])
    end
end
