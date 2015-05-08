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
			@product = FactoryGirl.create :product
			@order = FactoryGirl.create :order, user: current_user, product_ids: [@product.id]
			get :show, user_id: current_user, id: @order
		end
		
		it "returns the user order record matching the id" do
			expect(json_response[:order][:id]).to eql @order.id
		end
		
		it "includes the total for the order" do
			expect(json_response[:order][:total]).to eql @order.total.to_s
		end
		
		it "includes the products on the order" do
			expect(json_response[:order][:products].size).to eql 1
		end
		
		it { should respond_with 200 }
	end
	
	describe "POST #create" do
		before(:each) do
			current_user = FactoryGirl.create :user
			api_authorization_header current_user.auth_token
			
			product1 = FactoryGirl.create :product
			product2 = FactoryGirl.create :product
			
			order_params = { product_ids_and_quantities: [[product1.id, 2], [product2.id, 3]] }
			post :create, user_id: current_user, order: order_params
		end
		
		it "returns the correct user order record" do
			expect(json_response[:order][:id]).to be_present
		end
		
		it "embeds the two product objects related to the order" do
			expect(json_response[:order][:products].size).to eql 2
		end
		
		it { should respond_with 201 }
	end
end
