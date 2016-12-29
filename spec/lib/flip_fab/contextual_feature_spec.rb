module FlipFab
  describe ContextualFeature do
    let(:override)             {}
    let(:default)              { :disabled }
    let(:persistence_adapters) { [TestPersistence] }
    let(:feature)              { Feature.new :example_feature, default: default, persistence_adapters: persistence_adapters }
    let(:feature_states)       { { example_feature: :enabled } }
    let(:context)              { TestContext.new feature_states, 'example_feature' => override }
    subject { described_class.new feature, context }

    describe '.new' do
      it 'assigns the feature' do
        expect(subject.feature).to eq(feature)
      end

      it 'assigns the context' do
        expect(subject.context).to eq(context)
      end

      context 'when the feature has been overridden' do
        let(:override) { 'disabled' }

        it 'persists the override' do
          expect { subject }.to change { feature_states }.from(example_feature: :enabled).to(example_feature: :disabled)
        end

        context 'when the override provided is not one of enabled or disabled, it does not persist the override' do
          let(:override) { '' }

          it 'does not persist the override' do
            expect { subject }.not_to change { feature_states }.from(example_feature: :enabled)
          end
        end
      end
    end

    describe '#enabled?' do
      context 'when the feature is enabled in the adapter' do
        let(:feature_states) { { example_feature: :enabled } }

        it 'returns true' do
          expect(subject.enabled?).to be_truthy
        end

        context 'when the feature has been overridden' do
          let(:override) { 'disabled' }

          it 'returns false' do
            expect(subject.enabled?).to be_falsey
          end
        end
      end

      context 'when the feature is disabled in the adapter' do
        let(:feature_states) { { example_feature: :disabled } }

        it 'returns false' do
          expect(subject.enabled?).to be_falsey
        end
      end

      context 'when the feature is not specified in the adapter' do
        let(:feature_states) { {} }

        context 'when the default is :enabled' do
          let(:default) { :enabled }

          it 'returns true' do
            expect(subject.enabled?).to be_truthy
          end
        end

        context 'when the default is :disabled' do
          let(:default) { :disabled }

          it 'returns false' do
            expect(subject.enabled?).to be_falsey
          end
        end
      end

      context 'when there are multiple adapters' do
        let(:persistence_adapters) { [TestPersistence, TestMultiplePersistence] }

        context 'when the first adapter has enabled and the second adapter has nil' do
          let(:feature_states) { { example_feature: :enabled, different_example_feature: nil } }

          it 'returns true' do
            expect(subject.enabled?).to be_truthy
          end
        end

        context 'when the first adapter has nil and the second adapter has enabled' do
          let(:feature_states) { { example_feature: nil, different_example_feature: :enabled } }

          it 'returns true' do
            expect(subject.enabled?).to be_truthy
          end
        end

        context 'when the first adapter has disabled and the second adapter has enabled' do
          let(:feature_states) { { example_feature: :disabled, different_example_feature: :enabled } }

          it 'returns false' do
            expect(subject.enabled?).to be_falsey
          end
        end
      end
    end

    describe '#disabled?' do
      context 'when #enabled? returns true' do
        let(:feature_states) { { example_feature: :enabled } }

        it 'returns false' do
          expect(subject.disabled?).to be_falsey
        end
      end

      context 'when #enabled? returns false' do
        let(:feature_states) { { example_feature: :disabled } }

        it 'returns true' do
          expect(subject.disabled?).to be_truthy
        end
      end
    end

    describe '#state=' do
      context 'when the provided value is not :enabled or :disabled' do
        it 'raises' do
          expect { subject.state = '' }.to raise_error 'Invalid state provided: ``, possible states are :enabled, :disabled'
          expect { subject.state = 'enabled' }.to raise_error 'Invalid state provided: `enabled`, possible states are :enabled, :disabled'
        end
      end

      context 'when the provided value is :enabled or :disabled' do
        it 'changes the state of the feature' do
          expect { subject.state = :disabled }.to change { subject.enabled? }.from(true).to(false)
          expect { subject.state = :enabled }.to change { subject.enabled? }.from(false).to(true)
        end
      end
    end

    describe '#enable' do
      context 'when the state has been overridden' do
        let(:override) { 'disabled' }

        context 'and the persistence adapter has the opposite state' do
          let(:feature_states) { { example_feature: :disabled } }

          it 'does not change the state of the feature' do
            expect { subject.enable }.not_to change { subject.enabled? }.from(false)
          end

          it 'does not persist the state in the adapter' do
            expect_any_instance_of(TestPersistence).not_to receive(:write).with(:enabled)
            subject.enable
          end
        end
      end

      context 'when there are multiple persistence adapters' do
        let(:persistence_adapters) { [TestPersistence, TestMultiplePersistence] }
        let(:feature_states) { { example_feature: :disabled, different_example_feature: :disabled } }

        it 'changes the state of the feature' do
          expect { subject.enable }.to change { subject.enabled? }.from(false).to(true)
        end

        it 'persists the state in the adapters' do
          expect { subject.enable }.to change { feature_states }.from(example_feature: :disabled, different_example_feature: :disabled).to(example_feature: :enabled, different_example_feature: :enabled)
        end
      end

      context 'when there is a persistence adapter' do
        let(:persistence_adapters) { [TestPersistence] }

        context 'and the persistence adapter has the same state' do
          let(:feature_states) { { example_feature: :enabled } }

          it 'does not change the state of the feature' do
            expect { subject.enable }.not_to change { subject.enabled? }.from(true)
          end
        end

        context 'and the persistence adapter has the opposite state' do
          let(:feature_states) { { example_feature: :disabled } }

          it 'changes the state of the feature' do
            expect { subject.enable }.to change { subject.enabled? }.from(false).to(true)
          end

          it 'persists the state in the adapter' do
            expect { subject.enable }.to change { feature_states }.from(example_feature: :disabled).to(example_feature: :enabled)
          end
        end

        context 'and the persistence adapter has no state' do
          let(:feature_states) { {} }

          context 'and the feature is disabled' do
            let(:default) { :disabled }

            it 'changes the state of the feature' do
              expect { subject.enable }.to change { subject.enabled? }.from(false).to(true)
            end

            it 'persists the state in the adapter' do
              expect { subject.enable }.to change { feature_states }.from({}).to(example_feature: :enabled)
            end
          end

          context 'and the feature is enabled' do
            let(:default) { :enabled }

            it 'does not change the state of the feature' do
              expect { subject.enable }.not_to change { subject.enabled? }.from(true)
            end

            it 'persists the state in the adapter' do
              expect { subject.enable }.to change { feature_states }.from({}).to(example_feature: :enabled)
            end
          end
        end

        context 'when there is not a persistence adapter' do
          let(:persistence_adapters) { [] }

          context 'and the feature is enabled' do
            let(:default) { :enabled }

            it 'does not change the state of the feature' do
              expect { subject.enable }.not_to change { subject.enabled? }.from(true)
            end
          end

          context 'and the feature is disabled' do
            let(:default) { :disabled }

            it 'changes the state of the feature' do
              expect { subject.enable }.to change { subject.enabled? }.from(false).to(true)
            end
          end
        end
      end
    end

    describe '#disable' do
      context 'when the state has been overridden' do
        let(:override) { 'enabled' }

        context 'and the persistence adapter has the opposite state' do
          let(:feature_states) { { example_feature: :enabled } }

          it 'does not change the state of the feature' do
            expect { subject.disable }.not_to change { subject.disabled? }.from(false)
          end

          it 'does not persist the state in the adapter' do
            expect_any_instance_of(TestPersistence).not_to receive(:write).with(:disabled)
            subject.disable
          end
        end
      end

      context 'when there is a persistence adapter' do
        let(:persistence_adapters) { [TestPersistence] }

        context 'and the persistence adapter has the same state' do
          let(:feature_states) { { example_feature: :disabled } }

          it 'does not change the state of the feature' do
            expect { subject.disable }.not_to change { subject.disabled? }.from(true)
          end
        end

        context 'and the persistence adapter has the opposite state' do
          let(:feature_states) { { example_feature: :enabled } }

          it 'changes the state of the feature' do
            expect { subject.disable }.to change { subject.disabled? }.from(false).to(true)
          end

          it 'persists the state in the adapter' do
            expect_any_instance_of(TestPersistence).to receive(:write).with(:disabled)
            subject.disable
          end
        end

        context 'and the persistence adapter has no state' do
          let(:feature_states) { {} }

          context 'and the feature is enabled' do
            let(:default) { :enabled }

            it 'changes the state of the feature' do
              expect { subject.disable }.to change { subject.disabled? }.from(false).to(true)
            end

            it 'persists the state in the adapter' do
              expect_any_instance_of(TestPersistence).to receive(:write).with(:disabled)
              subject.disable
            end
          end

          context 'and the feature is disabled' do
            let(:default) { :disabled }

            it 'does not change the state of the feature' do
              expect { subject.disable }.not_to change { subject.disabled? }.from(true)
            end

            it 'persists the state in the adapter' do
              expect_any_instance_of(TestPersistence).to receive(:write).with(:disabled)
              subject.disable
            end
          end
        end

        context 'when there is not a persistence adapter' do
          let(:persistence_adapters) { [] }

          context 'and the feature is disabled' do
            let(:default) { :disabled }

            it 'does not change the state of the feature' do
              expect { subject.disable }.not_to change { subject.disabled? }.from(true)
            end
          end

          context 'and the feature is enabled' do
            let(:default) { :enabled }

            it 'changes the state of the feature' do
              expect { subject.disable }.to change { subject.disabled? }.from(false).to(true)
            end
          end
        end
      end
    end
  end
end
