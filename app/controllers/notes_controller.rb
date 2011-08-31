# coding: utf-8
class NotesController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :update_username
  layout :choose_layout

  def index
    @search = params[:search]
    if @search.blank?
      if current_user
        @notes = Note.find_my_notes(current_user.id)
      else
        @notes = Note.where(:private => false)
      end
    else
      if current_user
        @notes = Note.with_tag(@search, current_user.id)
      else
        @notes = Note.public_with_tag(@search)
      end
    end
    @username = current_user.username.downcase rescue nil
    @tags = Note.find_all_tags(@notes)
    respond_to do |format|
      format.js if request.xhr?
      format.html
    end
  end

  def show
    user_username = params[:user]
    note_id = params[:note_id]
    @user = User.find(:first, :conditions => [ "lower(username) = ?", user_username.downcase ])
    if !@user.blank?
      @note = Note.find_public_note(@user.id, note_id)
    end
  end

  def new
    @note = Note.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @note = Note.find(params[:id])
    redirect_to notes_path unless can_access?
  end

  def share
    note = Note.find(params[:id])
    note.private = false
    note.save
    respond_to do |format|
      format.js
    end
  end

  def create
    @note = Note.new(params[:note])
    @note.tag_list = params[:tags]
    @note.user_id = current_user.id
    respond_to do |format|
      if @note.save
        format.html { redirect_to(notes_url, :notice => 'Anotação criada com sucesso!') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @note = Note.find(params[:id])
    @note.tag_list = params[:tags]
    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to(notes_url, :notice => 'Anotação atualizada com sucesso!') }
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  def destroy
    @note = Note.find(params[:id])
    redirect_to notes_path unless can_access?
    @note.destroy
    respond_to do |format|
      format.html { redirect_to(notes_url) }
    end
  end

  def example
  end

  #Export all notes
  def export
      @notes = Note.find_my_notes(current_user.id)
      export_items = {'notes' => @notes.collect do |note|
        {'text' => note.text,
        'created' => note.created_at,
        'updated' => note.updated_at,
        'tags' => note.tags.collect {|t| t.name }}
      end }

      respond_to do |format|
        format.yaml { render :text => export_items.to_yaml }
      end
  end

private

  def choose_layout
    if [ 'show'].include? action_name
      'public'
    else
      'application'
    end
  end

  def update_username
    if !current_user.nil?
     redirect_to edit_user_registration_path if current_user.username.blank?
    end
  end

end

