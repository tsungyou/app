### Installation

_Below is the process for downloading flutter and running

1. download dart, flutter SDK
2. cmd + shift + P and enter "flutter: new project" for flutter installation(might take a few minutes)
3. after finished downloading, redo step 2, locating the flutter SDK when required, you would be able to choose "Flutter: Empty Project"
4. git clone under lib directory:
   ```sh 
   cd lib
   git clone ...
   ```

5. replace origin pubspec.yaml file with the same filename in you'd clone

6. update package 
   ```sh 
   flutter pub get
   ```
   or press Ctrl + S again for pubspec.yaml, the package would be updated automatically

7. run the project
   ```sh 
   flutter run
   ```