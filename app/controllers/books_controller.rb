class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    @user = current_user
    if params[:latest]
      @books = Book.latest
    elsif params[:star_count]
      @books = Book.star_count
    else 
      @books = Book.all
    end  
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end

  def update
    is_matching_login_user
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
  
  private

  def book_params
    params.require(:book).permit(:title, :body, :star, :category)
  end
  
  def is_matching_login_user
    book = Book.find(params[:id])
    user = book.user
    unless user == current_user
      redirect_to books_path
    end
  end
end
