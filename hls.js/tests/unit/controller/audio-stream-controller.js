import AudioStreamController from '../../../src/controller/audio-stream-controller';
import Hls from '../../../src/hls';
import { Events } from '../../../src/events';
import { FragmentTracker } from '../../../src/controller/fragment-tracker';
import KeyLoader from '../../../src/loader/key-loader';

describe('AudioStreamController', function () {
  const tracks = [
    {
      groupId: '1',
      id: 0,
      default: true,
      name: 'A',
    },
    {
      groupId: '1',
      id: 1,
      default: false,
      name: 'B',
    },
    {
      groupId: '1',
      id: 2,
      name: 'C',
    },
    {
      groupId: '2',
      id: 0,
      default: true,
      name: 'A',
    },
    {
      groupId: '2',
      id: 1,
      default: false,
      name: 'B',
    },
    {
      groupId: '3',
      id: 2,
      name: 'C',
    },
  ];

  let hls;
  let fragmentTracker;
  let keyLoader;
  let audioStreamController;

  beforeEach(function () {
    hls = new Hls();
    fragmentTracker = new FragmentTracker(hls);
    keyLoader = new KeyLoader({});
    audioStreamController = new AudioStreamController(
      hls,
      fragmentTracker,
      keyLoader,
    );
  });

  afterEach(function () {
    hls.destroy();
  });

  describe('onAudioTrackLoaded', function () {
    it('should update the level details from the event data', function () {
      const details = {
        live: false,
        fragments: [{}],
        targetduration: 100,
      };

      audioStreamController.levels = tracks;
      audioStreamController.mainDetails = details;
      audioStreamController.tick = () => {};

      audioStreamController.onAudioTrackLoaded(Events.AUDIO_TRACK_LOADED, {
        id: 0,
        details,
      });

      expect(audioStreamController.levels[0].details).to.equal(details);
    });
  });
});
