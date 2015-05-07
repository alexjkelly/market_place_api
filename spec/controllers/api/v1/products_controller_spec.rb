require 'spec_helper'

describe Api::V1::ProductsController do
	
	describe "GET #show" do
		before(:each) do
			@product = FactoryGirl.create :product
			get :show, id: @product
		end
		
		it "returns the information about the product" do
			expect(json_response[:title]).to eql @product.title
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
		
		it { should respond_with 200 }
	end
	
end
