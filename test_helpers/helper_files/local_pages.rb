# frozen_string_literal: true

def create_first_chapter = create_local_page 'where_new', 'https://archiveofourown.org/works/692/chapters/803'
def create_second_chapter = create_local_page 'hogwarts_new', 'https://archiveofourown.org/works/692/chapters/804'

# will create ch2
def update_partial_book
  create_first_chapter
  create_local_parent 'navigate_time', 'https://archiveofourown.org/works/692'
end

def create_book
  create_first_chapter
  create_second_chapter
  create_local_parent 'navigate_time', 'https://archiveofourown.org/works/692'
end

def recreate_first_chapter = recreate_local_page 'where', 'https://archiveofourown.org/works/692/chapters/803'
def recreate_second_chapter = recreate_local_page 'hogwarts', 'https://archiveofourown.org/works/692/chapters/804'

def create_book_with_old_html
  recreate_first_chapter
  recreate_second_chapter
  create_local_parent 'navigate_time', 'https://archiveofourown.org/works/692'
end

def create_chapter_as_single = create_local_page 'demonic', 'https://archiveofourown.org/works/4296198/chapters/9734529'

def create_single_chapter_book = create_local_page 'drive_new', 'https://archiveofourown.org/works/68481'

def create_first_single = create_local_page 'skipping', 'https://archiveofourown.org/works/688'

def create_second_single = create_local_page 'flower', 'https://archiveofourown.org/works/689'

def create_series
  create_first_single
  create_second_single
  create_local_parent 'drabbles', 'https://archiveofourown.org/series/46'
end

def create_multi_authors
  create_local_page 'multi', 'https://archiveofourown.org/works/29253276/chapters/71833074'
end
