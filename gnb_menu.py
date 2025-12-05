import gnb_db as db

VOICE_PARTS = ["Soprano", "Mezzo-Soprano", "Alto", "Tenor", "Baritone", "Bass"]

def main_menu():
    while True:
        print("\n=== GNB Database Menu ===")
        print("1. Members")
        print("2. Alumni")
        print("3. Songs")
        print("4. Arrangers")
        print("5. Events")
        print("6. Voice Parts")
        print("7. Performances")
        print("8. Exit")

        choice = input("Select an option: ").strip()

        if choice == "1":
            members_menu()
        elif choice == "2":
            alumni_menu()
        elif choice == "3":
            songs_menu()
        elif choice == "4":
            arrangers_menu()
        elif choice == "5":
            events_menu()
        elif choice == "6":
            voice_parts_menu()
        elif choice == "7":
            performances_menu()
        elif choice == "8":
            print("Goodbye!")
            break
        else:
            print("Invalid choice.")

# =======================================
# MEMBERS
# =======================================

def members_menu():
    while True:
        print("\n=== Members Menu ===")
        print("1. Add Member (all columns)")
        print("2. List Active Members")
        print("3. List Graduated Members (still in members)")
        print("4. Graduate Member (archives + removes)")
        print("5. Update Member Info")
        print("6. Delete Member (archives if not already)")
        print("7. Back")

        choice = input("Select an option: ").strip()

        if choice == "1":
            add_member_menu()
        elif choice == "2":
            list_active_members_menu()
        elif choice == "3":
            list_graduated_members_menu()
        elif choice == "4":
            graduate_member_menu()
        elif choice == "5":
            update_member_menu()
        elif choice == "6":
            delete_member_menu()
        elif choice == "7":
            break
        else:
            print("Invalid choice.")

def add_member_menu():
    print("\n=== Add a New Member ===")
    first_name = input("First name (required): ").strip()
    last_name  = input("Last name (required): ").strip()
    email      = input("Email (required): ").strip()

    phone_number = input("Phone number (blank = none): ").strip() or None
    vocal_range  = input("Vocal range (blank = none): ").strip() or None

    year_joined = input("Year joined (blank = none): ").strip()
    year_joined = int(year_joined) if year_joined else None

    expected_grad_year = input("Expected grad year (blank = none): ").strip()
    expected_grad_year = int(expected_grad_year) if expected_grad_year else None

    position_title = input("Position title (blank = none): ").strip() or None
    notes          = input("Notes (blank = none): ").strip() or None

    senior_song_id = input("Senior song ID (blank = none): ").strip()
    senior_song_id = int(senior_song_id) if senior_song_id else None

    try:
        db.add_member(first_name, last_name, email,
                      phone_number=phone_number,
                      vocal_range=vocal_range,
                      year_joined=year_joined,
                      expected_grad_year=expected_grad_year,
                      position_title=position_title,
                      notes=notes,
                      senior_song_id=senior_song_id)
        print("Member added!")
    except ValueError as ve:
        print("Error:", ve)

def list_active_members_menu():
    print("\n=== Active Members ===")
    members = db.list_members(active_only=True)
    if not members:
        print("No active members found.")
        return
    for m in members:
        print(f"{m['member_id']}: {m['first_name']} {m['last_name']} — {m['email']}"
              f" | joined {m['year_joined']} | exp grad {m.get('expected_grad_year')}")

def list_graduated_members_menu():
    print("\n=== Graduated Members (still in members) ===")
    rows = db.list_graduated_members()
    if not rows:
        print("No graduated members in members table.")
        return
    for m in rows:
        print(f"{m['member_id']}: {m['first_name']} {m['last_name']} — left {m['year_left']}")

def graduate_member_menu():
    print("\n=== Graduate Member ===")
    mid = input("Member ID to graduate: ").strip()
    if not mid.isdigit():
        print("Invalid ID.")
        return
    year_left = input("Actual leaving year (blank=current year): ").strip()
    year_left = int(year_left) if year_left else None

    db.graduate_member(int(mid), year_left)
    print("Graduated: archived to alumni and removed from members.")

def update_member_menu():
    print("\n=== Update Member Info ===")
    mid = input("Member ID: ").strip()
    if not mid.isdigit():
        print("Invalid ID.")
        return
    mid = int(mid)

    print("Leave any field blank to keep current value.")
    fields = {}

    v = input("First name: ").strip()
    if v: fields["first_name"] = v
    v = input("Last name: ").strip()
    if v: fields["last_name"] = v
    v = input("Email: ").strip()
    if v: fields["email"] = v
    v = input("Phone number: ").strip()
    if v: fields["phone_number"] = v
    v = input("Vocal range: ").strip()
    if v: fields["vocal_range"] = v

    v = input("Year joined: ").strip()
    if v: fields["year_joined"] = int(v)

    v = input("Expected grad year: ").strip()
    if v: fields["expected_grad_year"] = int(v)

    v = input("Position title: ").strip()
    if v: fields["position_title"] = v
    v = input("Notes: ").strip()
    if v: fields["notes"] = v

    v = input("Senior song ID: ").strip()
    if v: fields["senior_song_id"] = int(v)

    if fields:
        db.update_member(mid, **fields)
        print("Member updated.")
    else:
        print("No changes made.")

def delete_member_menu():
    print("\n=== Delete Member ===")
    mid = input("Member ID to delete: ").strip()
    if not mid.isdigit():
        print("Invalid ID.")
        return
    confirm = input("Are you sure? (y/n): ").strip().lower()
    if confirm == "y":
        db.delete_member(int(mid))
        print("Deleted from members (archived if needed).")
    else:
        print("Canceled.")

# =======================================
# ALUMNI
# =======================================

def alumni_menu():
    while True:
        print("\n=== Alumni Menu ===")
        print("1. List Alumni")
        print("2. Delete Alumni Member")
        print("3. Back")

        choice = input("Select an option: ").strip()

        if choice == "1":
            rows = db.list_alumni()
            print("\n=== Alumni ===")
            if not rows:
                print("No alumni yet.")
            for a in rows:
                print(f"{a['member_id']}: {a['first_name']} {a['last_name']} — "
                      f"{a['email']} (left {a['year_left']}) archived {a['archived_at']}")
        elif choice == "2":
            aid = input("Alumni member_id to delete: ").strip()
            if not aid.isdigit():
                print("Invalid ID.")
                continue
            confirm = input("Are you sure? (y/n): ").lower()
            if confirm == "y":
                db.delete_alumnus(int(aid))
                print("Alumnus deleted.")
            else:
                print("Canceled.")
        elif choice == "3":
            break
        else:
            print("Invalid choice.")

# =======================================
# SONGS
# =======================================

def songs_menu():
    while True:
        print("\n=== Songs Menu ===")
        print("1. Add Song (all columns)")
        print("2. List Songs")
        print("3. Back")

        choice = input("Select an option: ").strip()

        if choice == "1":
            add_song_menu()
        elif choice == "2":
            list_songs_menu()
        elif choice == "3":
            break
        else:
            print("Invalid choice.")

def add_song_menu():
    print("\n=== Add Song ===")
    title = input("Title (required): ").strip()

    arranger_id = input("Arranger ID (blank = none): ").strip()
    arranger_id = int(arranger_id) if arranger_id else None

    original_artist = input("Original artist (blank = none): ").strip() or None

    senior = input("Is senior song? (y/n, blank=no): ").strip().lower()
    is_senior_song = (senior == "y")

    notes = input("Notes (blank = none): ").strip() or None

    db.add_song(title, arranger_id=arranger_id,
                original_artist=original_artist,
                is_senior_song=is_senior_song,
                notes=notes)
    print("Song added.")

def list_songs_menu():
    print("\n=== Songs ===")
    rows = db.list_songs()
    if not rows:
        print("No songs found.")
        return
    for s in rows:
        print(f"{s['song_id']}: {s['title']} — {s.get('original_artist')}"
              f" | arranger_id={s.get('arranger_id')} | senior={s['is_senior_song']}")

# =======================================
# ARRANGERS
# =======================================

def arrangers_menu():
    while True:
        print("\n=== Arrangers Menu ===")
        print("1. Add Arranger (all columns)")
        print("2. List Arrangers")
        print("3. Back")

        choice = input("Select an option: ").strip()

        if choice == "1":
            add_arranger_menu()
        elif choice == "2":
            list_arrangers_menu()
        elif choice == "3":
            break
        else:
            print("Invalid choice.")

def add_arranger_menu():
    print("\n=== Add Arranger ===")
    name = input("Name (required): ").strip()
    email = input("Email (blank=none): ").strip() or None
    phone_number = input("Phone number (blank=none): ").strip() or None
    affiliation = input("Affiliation (blank=none): ").strip() or None
    avg_price = input("Average price (blank=none): ").strip()
    avg_price = float(avg_price) if avg_price else None
    notes = input("Notes (blank=none): ").strip() or None

    db.add_arranger(name, email=email, phone_number=phone_number,
                    affiliation=affiliation, avg_price=avg_price, notes=notes)
    print("Arranger added.")

def list_arrangers_menu():
    print("\n=== Arrangers ===")
    rows = db.list_arrangers()
    if not rows:
        print("No arrangers found.")
        return
    for a in rows:
        print(f"{a['arranger_id']}: {a['name']} — {a.get('email')}"
              f" | {a.get('affiliation')} | avg_price={a.get('avg_price')}")

# =======================================
# EVENTS
# =======================================

def events_menu():
    while True:
        print("\n=== Events Menu ===")
        print("1. Add Event (all columns)")
        print("2. List Events")
        print("3. Back")

        choice = input("Select an option: ").strip()

        if choice == "1":
            add_event_menu()
        elif choice == "2":
            list_events_menu()
        elif choice == "3":
            break
        else:
            print("Invalid choice.")

def add_event_menu():
    print("\n=== Add Event ===")
    event_name = input("Event name (required): ").strip()
    event_date = input("Event date YYYY-MM-DD (blank=none): ").strip() or None
    location = input("Location (blank=none): ").strip() or None
    contact_name = input("Contact name (blank=none): ").strip() or None
    contact_email = input("Contact email (blank=none): ").strip() or None
    contact_phone = input("Contact phone (blank=none): ").strip() or None

    db.add_event(event_name, event_date=event_date, location=location,
                 contact_name=contact_name, contact_email=contact_email,
                 contact_phone=contact_phone)
    print("Event added.")

def list_events_menu():
    print("\n=== Events ===")
    rows = db.list_events()
    if not rows:
        print("No events found.")
        return
    for e in rows:
        print(f"{e['event_id']}: {e['event_name']} — {e.get('event_date')} @ {e.get('location')}")

# =======================================
# VOICE PARTS
# =======================================

def voice_parts_menu():
    while True:
        print("\n=== Voice Parts Menu ===")
        print("1. Add Voice Part")
        print("2. Remove Voice Part")
        print("3. Show Member Voice Parts")
        print("4. Back")

        choice = input("Select an option: ").strip()

        if choice == "1":
            mid = input("Member ID: ").strip()
            if not mid.isdigit():
                print("Invalid ID.")
                continue
            print("Options:", ", ".join(VOICE_PARTS))
            part = input("Voice part: ").strip()
            db.add_voice_part(int(mid), part)
            print("Added.")

        elif choice == "2":
            mid = input("Member ID: ").strip()
            if not mid.isdigit():
                print("Invalid ID.")
                continue
            print("Options:", ", ".join(VOICE_PARTS))
            part = input("Voice part: ").strip()
            db.remove_voice_part(int(mid), part)
            print("Removed.")

        elif choice == "3":
            mid = input("Member ID: ").strip()
            if not mid.isdigit():
                print("Invalid ID.")
                continue
            parts = db.get_voice_parts(int(mid))
            print("Voice Parts:", parts if parts else "None")

        elif choice == "4":
            break
        else:
            print("Invalid choice.")

# =======================================
# PERFORMANCES
# =======================================

def performances_menu():
    while True:
        print("\n=== Performances Menu ===")
        print("1. Add Performance (all columns)")
        print("2. List Performances for Event")
        print("3. Back")

        choice = input("Select an option: ").strip()

        if choice == "1":
            add_performance_menu()
        elif choice == "2":
            list_performances_menu()
        elif choice == "3":
            break
        else:
            print("Invalid choice.")

def add_performance_menu():
    print("\n=== Add Performance ===")
    member_id = input("Member ID (required): ").strip()
    song_id   = input("Song ID (required): ").strip()
    event_id  = input("Event ID (required): ").strip()

    if not (member_id.isdigit() and song_id.isdigit() and event_id.isdigit()):
        print("IDs must be numbers.")
        return

    role = input("Role (blank=none): ").strip() or None

    db.add_performance(int(member_id), int(song_id), int(event_id), role=role)
    print("Performance added.")

def list_performances_menu():
    eid = input("Event ID: ").strip()
    if not eid.isdigit():
        print("Invalid ID.")
        return
    rows = db.list_performances_for_event(int(eid))
    if not rows:
        print("No performances for that event.")
        return

    print("\n=== Performances ===")
    for r in rows:
        print(f"{r['performance_id']}: {r['first_name']} {r['last_name']} — "
              f"{r['title']} | role={r.get('role')}")

# =======================================

if __name__ == "__main__":
    main_menu()
