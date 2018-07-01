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

  private

  def setup_update_params
    params.require(:code)
  end
end
