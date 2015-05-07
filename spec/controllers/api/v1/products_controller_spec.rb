require 'spec_helper'

describe Api::V1::ProductsController do
	
	describe "GET #show" do
		before(:each) do
			@product = FactoryGirl.create :product
			get :show, id: @product
		end
		
		it "returns the information about the product" do
			expect(json_response[:product][:title]).to eql @product.title
		end
		
		it "has a user as an embedded object" do
			expect(json_response[:product]).to have_key(:user)
		end
		
		it "has the correct user as an embedded object" do
			expect(json_response[:product][:user][:email]).to eql @product.user.email
		end
		
		it { should respond_with 200 }
	end
	
	describe "GET #index" do
		before(:each) do
			3.times { FactoryGirl.create :product }
			get :index
		end
		
		it "returns a list of all products" do
			expect(json_response[:products].size).to eq(3)
		end
		
		it "returns the user object with each product" do
			json_response[:products].each do |p|
				expect(p[:user]).to be_present
			end
		end
		
		it { should respond_with 200 }
	end
	
	describe "POST #create" do
		context "when successfully created" do
			before(:each) do
				user = FactoryGirl.create :user
				@product_attributes = FactoryGirl.attributes_for :product
				api_authorization_header user.auth_token
				post :create, { user_id: user, product: @product_attributes }
			end
			
			it "renders the json representation for the product just created" do
				expect(json_response[:product][:title]).to eql @product_attributes[:title]
			end
			
			it { should respond_with 201 }
		end
		
		context "when not created" do
			before(:each) do
				user = FactoryGirl.create :user
				@invalid_product_attributes = { title: "Cookies", price: "Bout treefiddy" }
				api_authorization_header user.auth_token
				post :create, { user_id: user, product: @invalid_product_attributes }
			end
			
			it "renders an errors json" do
				expect(json_response).to have_key(:errors)
			end
			
			it "renders the json errors relevant to why the product was not created" do
				expect(json_response[:errors][:price]).to include "is not a number"
			end
			
			it { should respond_with 422 }
		end
	end
	
	describe "PUT/PATCH #update" do
		before(:each) do
			@user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
		end
		
		context "when successfully updated" do
			before(:each) do
				patch :update, { user_id: @user, id: @product, 
												 product: { title: "New title" } }
			end
			
			it "renders the json for the updated product" do
				expect(json_response[:product][:title]).to eql "New title"
			end
			
			it { should respond_with 200 }
		end
		
		context "when not updated" do
			before(:each) do
				patch :update, { user_id: @user, id: @product, 
												 product: { price: "Bout treefiddy" } }
			end
			
			it "renders an errors json" do
				expect(json_response).to have_key(:errors)
			end
			
			it "renders errors json relevant to error" do
				expect(json_response[:errors][:price]).to include "is not a number"
			end
			
			it { should respond_with 422 }
		end
	end
	
	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			@product = FactoryGirl.create :product, user: @user
			api_authorization_header @user.auth_token
			delete :destroy, { user_id: @user, id: @product }
		end
		
		it { should respond_with 204 }
	end
end
