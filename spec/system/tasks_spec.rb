require 'rails_helper'

describe 'タスク管理機能', type: :system do
    let(:user_a) { FactoryBot.create(:admin_user, name: 'ユーザーA', email: 'a@example.com') }
    let(:user_b) { FactoryBot.create(:admin_user, name: 'ユーザーB', email: 'b@example.com') }
    let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }
    let!(:task_b) { FactoryBot.create(:task, name: '2番目のタスク', user: user_a, created_at: Time.current + 1.days) }

    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログインする'
    end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end
  
  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      # 作成済みのタスクの名称が画面上に表示されていることを確認
      it_behaves_like 'ユーザーAが作成したタスクが表示される' 
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      it 'ユーザーAが作成したタスクが表示されない' do
        # ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
        expect(page).to have_no_content '最初のタスク'
      end
    end

    context '複数のタスクを作成したとき' do
      let(:login_user) { user_a }

      it 'タスクが登録日時の降順で並んでいることを確認' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content '2番目のタスク'
        expect(task_list[1]).to have_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end
      
      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }

    before do
      visit new_task_path
      fill_in '名称', with: task_name
      click_button '登録する'
    end

    context '新規作成画面で名称を入力した時' do
      let(:task_name) { '新規作成のテストを書く' }

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end

    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end
  end
end

