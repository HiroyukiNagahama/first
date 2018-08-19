class PrefecturesController < ApplicationController

  def index
    @prefectures = Prefecture.all.order(:code)
  end

  def edit_ajax
    @goto_pref, @no_need_pref =  Prefecture.all.partition{|p| p.go_flag}
    render 'edit_ajax', layout: false
  end

  def update_ajax
    @p = Prefecture.find_by(code: setup_update_params)
    @p.update(go_flag: true)
    render partial: 'prefectures_list', locals: {pref: @p}
  end

  def delete_ajax
    @p = Prefecture.find_by(code: params[:code])
    @p.update(go_flag: false)
    render partial: 'prefectures_list', locals: {pref: @p}
  end

  # trip#indexで使用
  def load_index
    @prefectures = Prefecture.all.order(:code)
    render json: @prefectures
  end

  def load_user
    render json: { code: '08', current_company_code: '3' }
  end

  def add_prefecture
    pref = Prefecture.new(add_prefecture_params)
    p add_prefecture_params
    pref.go_flag = false
    pref.save!
    render json: pref
  end

  def lists
    a = Prefecture.all.collect{|p| { name: p.name } }
    p a
    render json: a
  end

  def edit_vue
    @prefecture = Prefecture.first
    render json: @prefecture
  end

  private

  def setup_update_params
    params.require(:code)
  end

  def add_prefecture_params
    params.require(:prefecture).permit(:name, :code)
  end
end
