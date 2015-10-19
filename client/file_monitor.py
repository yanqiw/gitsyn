import sys
import os
import time
import logging
from watchdog.observers import Observer
from watchdog.events import LoggingEventHandler, PatternMatchingEventHandler

class gitCommit(PatternMatchingEventHandler):
    def __init__(self):
      super(gitCommit, self).__init__(ignore_patterns=["*/.git", "*/.git/*"])

    def process(self, event):
        print '============', time.time()
        print event.src_path, event.event_type # print now only for degug
        os.system('git add -A')
        os.system('git commit -m ' + str(time.time()))

    def on_any_event(self, event):
        self.process(event)

    pass

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(message)s',
                        datefmt='%Y-%m-%d %H:%M:%S')
    path = sys.argv[1] if len(sys.argv) > 1 else '.'
    event_handler = LoggingEventHandler()
    observer = Observer()
    observer.schedule(gitCommit(), path, recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()