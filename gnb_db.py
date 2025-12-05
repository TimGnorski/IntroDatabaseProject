import mysql.connector
from mysql.connector import IntegrityError
from contextlib import contextmanager
from typing import List, Optional, Tuple, Dict, Any

# =========================
# CONFIG
# =========================

DB_NAME = "gnb_acapella"

config = {
    "user": "root",
    "password": "dinosauR4*",   # <-- change if needed
    "host": "127.0.0.1",
    "auth_plugin": "caching_sha2_password",
    "database": DB_NAME
}

# =========================
# CONNECTION HELPERS
# =========================

@contextmanager
def get_conn_cursor():
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    try:
        yield conn, cursor
        conn.commit()
    finally:
        cursor.close()
        conn.close()


def run_query(query: str, params: Tuple = (), fetch: bool = False):
    with get_conn_cursor() as (conn, cursor):
        cursor.execute(query, params)
        if fetch:
            return cursor.fetchall()
        return None

# =========================
# MEMBERS
# =========================

def add_member(first_name: str, last_name: str, email: str,
               phone_number: Optional[str] = None,
               vocal_range: Optional[str] = None,
               year_joined: Optional[int] = None,
               expected_grad_year: Optional[int] = None,
               position_title: Optional[str] = None,
               notes: Optional[str] = None,
               senior_song_id: Optional[int] = None) -> None:
    """
    Add active member. expected_grad_year can be future.
    year_left should stay NULL until they actually leave.
    """
    query = """
    INSERT INTO members
      (first_name, last_name, email, phone_number, vocal_range,
       year_joined, expected_grad_year, year_left,
       position_title, notes, senior_song_id)
    VALUES (%s,%s,%s,%s,%s,%s,%s,NULL,%s,%s,%s)
    """
    try:
        run_query(query, (
            first_name, last_name, email, phone_number, vocal_range,
            year_joined, expected_grad_year,
            position_title, notes, senior_song_id
        ))
    except IntegrityError as e:
        if "uq_members_email" in str(e):
            raise ValueError(f"A member with email {email} already exists.")
        raise


def update_member(member_id: int, **fields) -> None:
    allowed = {
        "first_name", "last_name", "email", "phone_number", "vocal_range",
        "year_joined", "expected_grad_year", "year_left",
        "position_title", "notes", "senior_song_id"
    }
    if not fields:
        return

    set_parts = []
    values = []
    for k, v in fields.items():
        if k not in allowed:
            raise ValueError(f"Field '{k}' not allowed.")
        set_parts.append(f"{k} = %s")
        values.append(v)

    query = f"UPDATE members SET {', '.join(set_parts)} WHERE member_id = %s"
    values.append(member_id)
    run_query(query, tuple(values))


def get_member(member_id: int) -> Optional[Dict[str, Any]]:
    rows = run_query("SELECT * FROM members WHERE member_id = %s",
                     (member_id,), fetch=True)
    return rows[0] if rows else None


def list_members(active_only: bool = True) -> List[Dict[str, Any]]:
    if active_only:
        query = """
        SELECT * FROM members
        WHERE year_left IS NULL
        ORDER BY last_name, first_name
        """
        return run_query(query, fetch=True)
    return run_query("SELECT * FROM members ORDER BY last_name, first_name",
                     fetch=True)


def list_graduated_members() -> List[Dict[str, Any]]:
    query = """
    SELECT * FROM members
    WHERE year_left IS NOT NULL
    ORDER BY year_left DESC, last_name, first_name
    """
    return run_query(query, fetch=True)


def delete_member(member_id: int) -> None:
    # BEFORE DELETE trigger moves to alumni if not already there
    run_query("DELETE FROM members WHERE member_id = %s", (member_id,))


def graduate_member(member_id: int, year_left: Optional[int] = None) -> None:
    """
    This is REAL graduation/leaving year (<= current year typically).
    1) set year_left -> trigger archives to alumni
    2) delete from members -> removes from active list
    """
    if year_left is None:
        import datetime
        year_left = datetime.datetime.now().year

    update_member(member_id, year_left=year_left)
    delete_member(member_id)


def delete_graduated_members() -> None:
    run_query("DELETE FROM members WHERE year_left IS NOT NULL")


# =========================
# ALUMNI
# =========================

def list_alumni() -> List[Dict[str, Any]]:
    return run_query("SELECT * FROM alumni ORDER BY last_name, first_name", fetch=True)


def delete_alumnus(member_id: int) -> None:
    run_query("DELETE FROM alumni WHERE member_id = %s", (member_id,))


# =========================
# VOICE PARTS
# =========================

def add_voice_part(member_id: int, voice_part: str) -> None:
    query = """
    INSERT IGNORE INTO member_voice_parts (member_id, voice_part)
    VALUES (%s, %s)
    """
    run_query(query, (member_id, voice_part))


def remove_voice_part(member_id: int, voice_part: str) -> None:
    query = """
    DELETE FROM member_voice_parts
    WHERE member_id = %s AND voice_part = %s
    """
    run_query(query, (member_id, voice_part))


def get_voice_parts(member_id: int) -> List[str]:
    rows = run_query("""
        SELECT voice_part FROM member_voice_parts
        WHERE member_id = %s
    """, (member_id,), fetch=True)
    return [r["voice_part"] for r in rows]


# =========================
# ARRANGERS
# =========================

def add_arranger(name: str,
                 email: Optional[str] = None,
                 phone_number: Optional[str] = None,
                 affiliation: Optional[str] = None,
                 avg_price: Optional[float] = None,
                 notes: Optional[str] = None) -> None:
    query = """
    INSERT INTO arrangers
      (name, email, phone_number, affiliation, avg_price, notes)
    VALUES (%s,%s,%s,%s,%s,%s)
    """
    run_query(query, (name, email, phone_number, affiliation, avg_price, notes))


def list_arrangers() -> List[Dict[str, Any]]:
    return run_query("SELECT * FROM arrangers ORDER BY name", fetch=True)


# =========================
# SONGS
# =========================

def add_song(title: str,
             arranger_id: Optional[int] = None,
             original_artist: Optional[str] = None,
             is_senior_song: bool = False,
             notes: Optional[str] = None) -> None:
    query = """
    INSERT INTO songs
      (title, arranger_id, original_artist, is_senior_song, notes)
    VALUES (%s,%s,%s,%s,%s)
    """
    run_query(query, (title, arranger_id, original_artist, is_senior_song, notes))


def list_songs() -> List[Dict[str, Any]]:
    return run_query("SELECT * FROM songs ORDER BY title", fetch=True)


# =========================
# EVENTS
# =========================

def add_event(event_name: str,
              event_date: Optional[str] = None,
              location: Optional[str] = None,
              contact_name: Optional[str] = None,
              contact_email: Optional[str] = None,
              contact_phone: Optional[str] = None) -> None:
    query = """
    INSERT INTO events
      (event_name, event_date, location, contact_name, contact_email, contact_phone)
    VALUES (%s,%s,%s,%s,%s,%s)
    """
    run_query(query, (event_name, event_date, location,
                      contact_name, contact_email, contact_phone))


def list_events() -> List[Dict[str, Any]]:
    return run_query("SELECT * FROM events ORDER BY event_date", fetch=True)


# =========================
# PERFORMANCES
# =========================

def add_performance(member_id: int, song_id: int, event_id: int,
                    role: Optional[str] = None) -> None:
    query = """
    INSERT IGNORE INTO performances
      (member_id, song_id, event_id, role)
    VALUES (%s,%s,%s,%s)
    """
    run_query(query, (member_id, song_id, event_id, role))


def list_performances_for_event(event_id: int) -> List[Dict[str, Any]]:
    query = """
    SELECT p.performance_id, p.role,
           m.member_id, m.first_name, m.last_name,
           s.song_id, s.title,
           e.event_id, e.event_name
    FROM performances p
    JOIN members m ON p.member_id = m.member_id
    JOIN songs s ON p.song_id = s.song_id
    JOIN events e ON p.event_id = e.event_id
    WHERE p.event_id = %s
    ORDER BY s.title, m.last_name
    """
    return run_query(query, (event_id,), fetch=True)
