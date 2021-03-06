require 'rails_helper'

RSpec.describe Video, type: :model do
  context "associations" do
    it {is_expected.to belong_to(:user).as_inverse_of(:video) }
  end

  context 'AASM state machine' do
    subject(:video) {FactoryBot.build(:video)}

    specify { expect(video.aasm.states.map(&:name)).to eql [:scheduled, :processing, :done, :failed] }

    specify { expect(video).to transition_from(:failed).to(:scheduled).on_event(:schedule) }
    specify { expect(video).to transition_from(:scheduled).to(:processing).on_event(:start) }
    specify { expect(video).to transition_from(:processing).to(:done).on_event(:completed) }
    specify { expect(video).to transition_from(:processing).to(:failed).on_event(:fail) }

    context 'when video in processing' do
      subject(:video_processing) do
        video.aasm_state = "processing"
        video
      end

      specify { expect { video_processing.start! }.to raise_exception(AASM::InvalidTransition)}
      specify "should  failed if shedule state" do
        expect {video_processing.schedule! }.to raise_exception(AASM::InvalidTransition)
      end
    end

    context 'when video is uploaded (state: done)' do
      subject(:video_done) do
        video.aasm_state = 'done'
        video
      end

      specify "should failed (state: start)" do
        expect {video_done.start!}.to raise_exception(AASM::InvalidTransition)
      end

      specify "should failed (state: completed)" do
        expect {video_done.completed!}.to raise_exception(AASM::InvalidTransition)
      end

      specify "should failed (state: fail)" do
        expect {video_done.fail!}.to raise_exception(AASM::InvalidTransition)
      end

    end

    context 'when video is failed' do
      subject(:video_failed) do
        video.aasm_state = 'failed'
        video
      end

      specify "should failed if the same state" do
        expect { video_failed.fail! }.to raise_exception(AASM::InvalidTransition)
      end

      specify "should raise if start state" do
        expect { video_failed.start! }.to raise_exception(AASM::InvalidTransition)
      end

      specify "should raise if completed state " do
        expect { video_failed.completed! }.to raise_exception(AASM::InvalidTransition)
      end
    end

    context 'state machine logic' do
      before do
        @video = FactoryBot.create(:video)
      end

      context 'from schedule to processing' do
        it "should set output_video_processing flag" do
          expect{@video.start!}.to change {
            @video.output_video_processing
          }.from(false).to(true)
        end
      end

      context 'from processing to done' do
        before do
          @video.update_attributes(aasm_state: 'processing', output_video_processing: true)
        end

        it 'should set output_video_processing' do
          expect { @video.completed! }.to change {@video.output_video_processing}.from(true).to(false)
        end
      end

      context 'from processing to fail' do
        before do
          @video.update_attributes(aasm_state: 'processing',output_video_processing: true)
        end

        it 'should set output_video_processing attribute' do
          expect { @video.fail! }.to change {@video.output_video_processing}.from(true).to(false)
        end
      end

      context 'from failed to scheduled' do
        before do
          @video.update_attributes(aasm_state: 'failed', output_video_processing: false)
        end

        it 'should set output_video_processing to true' do
          expect{@video.schedule!}.to change { @video.output_video_processing }.from(false).to(true)
        end
      end

    end


  end
end
