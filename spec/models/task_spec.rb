require 'rails_helper'

RSpec.describe Task, type: :model do

  describe 'name属性の検証' do

    describe '有無の検証' do
      context 'name属性があるとき' do
        it 'タスクが正常に登録される' do
          user = FactoryBot.create(:admin_user)
          task = user.tasks.new(name: '正常登録')
          # task.valid? がtrueになればパスする
          expect(task).to be_valid
        end
      end

      context 'name属性がないとき' do
        it 'タスクが登録されない' do
          user = FactoryBot.create(:admin_user)
          task = user.tasks.new(name: '')
          expect(task).not_to be_valid
        end
      end
    end

    describe '30文字までの検証' do
      
      context '30文字以内のとき' do
        it 'タスクが正常に登録される' do
          user = FactoryBot.create(:admin_user)
          task = user.tasks.new(name: '123456789022345678903234567890')
          # task.valid? がtrueになればパスする
          expect(task).to be_valid
        end
      end
    
      context '31文字以上のとき' do
        it 'タスクが登録されない' do
          user = FactoryBot.create(:admin_user)
          task = user.tasks.new(name: '1234567890223456789032345678904')
          expect(task).not_to be_valid
        end
      end
    
    end

    describe 'カンマを含めることができないことの検証' do
      context 'カンマを含まないとき' do
        it 'タスクが正常に登録される' do
          user = FactoryBot.create(:admin_user)
          task = user.tasks.new(name: 'ABCDEF')
          expect(task).to be_valid
        end
      end

      context 'カンマを含むとき' do
        it 'タスクが登録されない' do
          user = FactoryBot.create(:admin_user)
          task = user.tasks.new(name: 'ABC,DEF')
          expect(task).not_to be_valid
        end
      end
    end
  end
end
