class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # 投稿数の表示に使用
  # 上から今日の投稿数、前日の投稿数、今週の投稿数、前週の投稿数
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } #今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } #前日
  scope :created_2day, -> { where(created_at: 2.days.ago.all_day) } #2日前
  scope :created_3day, -> { where(created_at: 3.days.ago.all_day) } #3日前
  scope :created_4day, -> { where(created_at: 4.days.ago.all_day) } #4日前
  scope :created_5day, -> { where(created_at: 5.days.ago.all_day) } #5日前
  scope :created_6day, -> { where(created_at: 6.days.ago.all_day) } #6日前
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } #今週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } #前週



  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect"
      Book.where("title LIKE?","#{word}")
    elsif search == "forward"
      Book.where("title LIKE?","#{word}%")
    elsif search == "backward"
      Book.where("title LIKE?","%#{word}")
    else search == "partial"
      Book.where("title LIKE?","%#{word}%")
    end
  end

end
