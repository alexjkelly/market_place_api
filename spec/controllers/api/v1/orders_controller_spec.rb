require 'spec_helper'

describe Api::V1::OrdersController do
	describe "GET #index" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token
			4.times { FactoryGirl.create :order, user: current_user }
			get :index, user_id: current_user
		end
		
		it "returns 4 order records from the user" do
			expect(json_response[:orders].size).to eq(4)
		end

		it { should respond_with 200 }
	end
	
	describe "GET #show" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token
			@order = FactoryGirl.create :order, user: current_user
			get :show, user_id: current_user, id: @order
		end
		
		it "returns the user order record matching the id" do
			expect(json_response[:order][:id]).to eql @order.id
		end
		
		it { should respond_with 200 }
	end
	
	describe "POST #create" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token
			
			product1 = FactoryGirl.create :product
			product2 = FactoryGirl.create :product
			
			order_params = { product_ids: [product1, product2] }
			post :create, user_id: current_user, order: order_params
		end
		
		it "returns the correct user order record" do
			expect(json_response[:order][:id]).to be_present
		end
		
		it { should respond_with 201 }
	end
end
