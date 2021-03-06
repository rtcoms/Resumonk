class Resume < ActiveRecord::Base
  belongs_to :user
  
  has_many :educations
  accepts_nested_attributes_for :educations, :reject_if => lambda { |a| a[:institute_name].blank? }, :allow_destroy => true
  
  has_many :experiences
  accepts_nested_attributes_for :experiences, :reject_if => lambda { |a| a[:company_name].blank? }, :allow_destroy => true
  
  has_many :skills
  accepts_nested_attributes_for :skills, :reject_if => lambda { |a| a[:skill].blank? }, :allow_destroy => true
  
  validates :firstname, :lastname, :address, presence: true
  validates :website, format: { with: /^(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix }, allow_blank: true
  # validates :phone, format: { with: /[0-9]{10}/ }, allow_blank: true
  
  before_create :create_short_link
  has_many :visits
  
  amoeba do
    enable
    include_field :educations
    include_field :experiences
    include_field :skills
    clone [:educations, :experiences, :skills]
  end
  
  private
    def create_short_link
      self.short_link = Rufus::Mnemo.from_i(rand(8**5))
    end
end
