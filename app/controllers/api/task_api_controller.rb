class Api::TaskApiController < ApplicationController

  # GET /tasks
  def index
    # 後々のため、更新順で返します
    @tasks = Task.order('updated_at DESC')
    render json: @tasks
  end

  # POST /tasks
  def create
    p 'access'

    @task = Task.new(task_params)
p @task.valid?
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      render :show, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task_api).fetch(:task, {}).permit(:name, :is_done)
    # params.fetch(:task_api, {}).permit(
    #     :name, :is_done
    # )
  end
end
