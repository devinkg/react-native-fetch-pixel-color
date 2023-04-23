import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-fetch-pixel-color' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const FetchPixelColor = NativeModules.FetchPixelColor
  ? NativeModules.FetchPixelColor
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const rgb2hex = (rgb: string | any[]) => {
  return (rgb && rgb.length === 3) ? '#' +
    ('0' + parseInt(rgb[0], 10).toString(16)).slice(-2) +
    ('0' + parseInt(rgb[1], 10).toString(16)).slice(-2) +
    ('0' + parseInt(rgb[2], 10).toString(16)).slice(-2) : '';
};

export const setImageAndroid = (path: any) => new Promise((resolve, reject) => {
  FetchPixelColor.setImage(path, (err: any, isSet: any) => {
    if (err) {
      return reject(err);
    }
    if (isSet) {
      resolve('The image has been set sucessfully');
    }
  });
});

export const pickColorOfPixelAndroid = (x: any, y: any) => new Promise((resolve, reject) => {
  FetchPixelColor.getRGB(x, y, (err: any, color: any) => {
    if (err) {
      return reject(err);
    }
    resolve(rgb2hex(color).toUpperCase());
  });
});

export function multiply(a: number, b: number): Promise<number> {
  return FetchPixelColor.multiply(a, b);
}
