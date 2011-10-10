class Vendor < ActiveRecord::Base
	has_and_belongs_to_many :products, :foreign_key => 'unconventional_id'
	validates_presence_of   :name
	validates_length_of     :name, :in => 5..250
	validates_uniqueness_of :name
end
