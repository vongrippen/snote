class Note < ActiveRecord::Base
  belongs_to :user
  acts_as_taggable_on :tags
  validates_presence_of :text

  def self.find_my_notes(current_user_id)
    all(:conditions => "notes.user_id = #{current_user_id}",:order=>"id DESC")
  end

  def self.find_all_tags(notes)
    tags = []
    notes.each do |note|
      note.tags.each{|tag| tags << tag.name if !tags.include?(tag.name)}
    end
    tags
  end

  def self.with_tag(tag, current_user_id)
    cols = self.column_names.collect {|c| "notes.#{c}"}.join(",") #Postgres fix
    all(:conditions => ["tags.name LIKE ? AND notes.user_id = ?","%#{eval("tag")}%", current_user_id],
        :joins => "INNER JOIN taggings ON taggings.taggable_id = notes.id
          INNER JOIN tags ON taggings.tag_id = tags.id",:group => cols)
  end
  
  def self.public_with_tag(tag)
    cols = self.column_names.collect {|c| "notes.#{c}"}.join(",") #Postgres fix
    all(:conditions => ["tags.name LIKE ? AND notes.private = ?","%#{eval("tag")}%", false],
        :joins => "INNER JOIN taggings ON taggings.taggable_id = notes.id
          INNER JOIN tags ON taggings.tag_id = tags.id",:group => cols)
  end

  def self.find_public_note(user_id, note_id)
    Note.all(:conditions => {:private => false, :user_id => user_id, :id => note_id}).first
  end
end

