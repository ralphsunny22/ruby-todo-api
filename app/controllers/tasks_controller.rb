class TasksController < ApplicationController
  before_action :authorize
  before_action :set_task, only: %i[ show update destroy ]

  # GET /tasks
  def index
    #@user is coming frm authorize in ApplicationController
    # @tasks = Task.alls
    @tasks = @user.tasks.all

    render json: @tasks
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    # @task = Task.new(task_params)
    #instead passing user from request, we merge to jwt-user to existing request params. For this rzn we remove 'user_id' frm "task_params" mtd
    @task = Task.new(task_params.merge(user: @user))

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      # @task = Task.find(params[:id])
      # @task = @user.tasks.find(params[:id])
      @task = @user.tasks.find_by(:id => params[:id])
      if @task
        @task
      else
        @response = {
              :status => 400,
              :message => "Task does not exist",
          }
          render json: @response, status: 400
      end
    end

    # Only allow a list of trusted parameters through.
    def task_params
      # params.require(:task).permit(:title, :user_id)
      params.require(:task).permit(:title)
    end
end
