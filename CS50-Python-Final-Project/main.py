import pyttsx3

engine = pyttsx3.init()
voices = engine.getProperty("voices")
engine.setProperty("voice", voices[0].id)
volume = engine.getProperty("volume")
engine.setProperty("volume", 1.0)


def main():
    # Get the players' names
    name_player1: str = get_name("Player 1")
    name_player2: str = get_name("Player 2")

    # Establish the amount of points from which both players will start
    required_points: int = get_required_points()

    # Ask how many legs are required to win the match and assign the necessary variables
    required_legs: int = get_required_legs()
    best_of_legs: int = required_legs * 2 - 1
    legs_player1: int = 0
    total_turns_player1: float = 0.0
    total_score_player1: int = 0
    legs_player2: int = 0
    total_turns_player2: float = 0.0
    total_score_player2: int = 0

    # Loop through legs until someone wins enough legs
    for leg in range(1, best_of_legs + 1):
        # Announcing who should start the leg, depending on legs played
        if leg % 2 == 0:
            call_start(leg, name_player2)
        else:
            call_start(leg, name_player1)

        # Setting or resetting each player's remaining points and turns
        required_player1: int = required_points
        required_player2: int = required_points
        turns_player1: int = 0
        turns_player2: int = 0

        # Players take turns until one of them gets their points to zero
        while True:
            # Determine player to throw first. In even legs the first iteration over Player1 should be skipped
            if leg % 2 == 0 and turns_player2 == 0:
                pass
            else:
                # Player1's turn
                turns_player1 += 1
                total_turns_player1 += 1
                call_required(name_player1, required_player1)
                throw_player1: int = get_throw()
                score_player1: int = calculate_score(required_player1, throw_player1)
                total_score_player1 = total_score_player1 + score_player1
                required_player1 = required_player1 - score_player1
                if required_player1 == 0:
                    legs_player1 += 1
                    if legs_player1 == required_legs:
                        call_match(name_player1)
                    else:
                        call_leg(name_player1)
                    break
                call_score(score_player1)
                print(f"{name_player1}, your remaining score is {required_player1}")

            # Player2's turn
            turns_player2 += 1
            total_turns_player2 += 1
            call_required(name_player2, required_player2)
            throw_player2: int = get_throw()
            score_player2: int = calculate_score(required_player2, throw_player2)
            total_score_player2 = total_score_player2 + score_player2
            required_player2 = required_player2 - score_player2
            if required_player2 == 0:
                legs_player2 += 1
                if legs_player2 == required_legs:
                    call_match(name_player2)
                else:
                    call_leg(name_player2)
                break
            call_score(score_player2)
            print(f"{name_player2}, your remaining score is {required_player2}")

        # Assign winner/loser variables to calculate the 3-dart average
        if required_player1 == 0:
            leg_winner: str = name_player1
            leg_loser: str = name_player2
            final_throw: int = throw_player1
            turns_leg_winner: int = turns_player1
            turns_leg_loser: int = turns_player2
            leg_loser_remaining: int = required_player2
        else:
            leg_winner: str = name_player2
            leg_loser: str = name_player1
            final_throw: int = throw_player2
            turns_leg_winner: int = turns_player2
            turns_leg_loser: int = turns_player1
            leg_loser_remaining: int = required_player1

        # Get the amount of darts needed to finish in the final turn to accurately calculate the winner's 3-dart average
        final_darts: int = get_final_darts(final_throw, leg_winner)
        if leg_winner == name_player1:
            turns_leg_winner = turns_player1 - (3 - final_darts) / 3
            total_turns_player1 = total_turns_player1 - (3 - final_darts) / 3
        else:
            turns_leg_winner = turns_player2 - (3 - final_darts) / 3
            total_turns_player2 = total_turns_player2 - (3 - final_darts) / 3

        calculate_avg_winner(leg_winner, required_points, turns_leg_winner)
        calculate_avg_loser(
            leg_loser, required_points, turns_leg_loser, leg_loser_remaining
        )
        call_legs_won(name_player1, legs_player1, name_player2, legs_player2)

        if legs_player1 == required_legs or legs_player2 == required_legs:
            break

    calculate_avg_match(name_player1, total_score_player1, total_turns_player1)
    calculate_avg_match(name_player2, total_score_player2, total_turns_player2)


def get_name(player: str) -> str:
    while True:
        try:
            name: str = input(f"{player}, what's your name? ")
            if not name:
                raise ValueError
        except ValueError:
            print("Please enter a name.")
            pass
        else:
            return name


def get_required_points() -> int:
    while True:
        try:
            required_points: int = int(
                input("With what score would you like to start? ")
            )
            if required_points < 2:
                raise ValueError
        except ValueError:
            print("Please enter a valid number")
            pass
        else:
            return required_points


def get_required_legs() -> int:
    while True:
        try:
            required_legs: int = int(
                input("How many legs are needed to win the match? ")
            )
            if required_legs < 1:
                raise ValueError
        except ValueError:
            print("Please enter a positive number.")
            pass
        else:
            return required_legs


def call_start(leg: int, name: str) -> None:
    print(f"Leg {leg}, {name} to throw first. Game on!")
    engine.say(f"Leg {leg}, {name} to throw first. Game on!")
    engine.runAndWait()


def call_required(name: str, required: int) -> None:
    bogey_numbers: list = [159, 162, 163, 165, 166, 168, 169]
    print(f"{name}, you require {required}")
    if required < 171 and required not in bogey_numbers:
        engine.say(f"{name}, you require {required}")
        engine.runAndWait()


def get_throw() -> int:
    impossible_throws: list = [163, 166, 169, 172, 173, 175, 176, 178, 179]
    while True:
        try:
            throw: int = int(input("Score: "))
            if throw > 180 or throw in impossible_throws:
                raise ValueError
        except ValueError:
            print("Please enter a valid score.")
            pass
        else:
            return throw


def calculate_score(required: int, throw: int) -> int:
    impossible_finishes: list = [159, 162, 165, 168, 171, 174, 180]
    if (
        required - throw == 1
        or throw > required
        or required == throw
        and throw in impossible_finishes
    ):
        score = 0
        return score
    else:
        score = throw
        return score


def call_match(name: str) -> None:
    print(f"Game shot and the match, {name}!")
    engine.say(f"Game shot and the match, {name}!")
    engine.runAndWait()


def call_leg(name: str) -> None:
    print(f"Game shot, {name}!")
    engine.say(f"Game shot, {name}!")
    engine.runAndWait()


def call_score(score: int) -> None:
    if score > 0:
        engine.say(score)
        engine.runAndWait()
    else:
        print("No score.")
        engine.say("No score.")
        engine.runAndWait()


def get_final_darts(final_throw: int, leg_winner: str) -> int:
    three_dart_finishes: list = [
        99,
        102,
        103,
        105,
        106,
        108,
        109,
        *[x for x in range(111, 159)],
        160,
        161,
        164,
        167,
        170,
    ]
    two_dart_finishes: list = [
        *[x for x in range(3, 40) if x % 2 == 1],
        *[x for x in range(41, 50)],
        *[x for x in range(51, 99)],
        100,
        101,
        104,
        107,
        110,
    ]
    while True:
        if final_throw in three_dart_finishes:
            return 3
        else:
            try:
                x: int = int(
                    input(f"How many darts did you need to finsh, {leg_winner}? ")
                )
                if x < 1 or x > 3:
                    raise ValueError
                elif final_throw in two_dart_finishes and x < 2:
                    raise ValueError
            except ValueError:
                print("Please enter a valid amount of darts.")
                pass
            else:
                return x


def calculate_avg_winner(name: str, required: int, turns: int) -> None:
    avg: float = round(required / turns, 2)
    print(f"{name}, your 3-dart average for this leg was {avg}.")


def calculate_avg_loser(name: str, required: int, turns: int, remaining: int) -> None:
    try:
        avg: float = round((required - remaining) / turns, 2)
    except ZeroDivisionError:
        print(f"{name}, you didn't even get to throw a single dart.")
    else:
        print(f"{name}, your 3-dart average for this leg was {avg}.")


def call_legs_won(name1: str, legs1: int, name2: str, legs2: int) -> None:
    print(f"Legs won\n{name1} {legs1} - {legs2} {name2}")
    if legs1 == 1:
        engine.say(f"{name1} has won {legs1} leg, {name2} has won {legs2}")
        engine.runAndWait()
    else:
        engine.say(f"{name1} has won {legs1} legs, {name2} has won {legs2}")
        engine.runAndWait()


def calculate_avg_match(name: str, score: int, turns: int) -> None:
    try:
        match_avg: float = round(score / turns, 2)
    except ZeroDivisionError:
        print(
            f"What happened, {name}? You weren't allowed to throw a single dart this match?"
        )
    else:
        print(f"{name}, you averaged {match_avg} for this match.")


if __name__ == "__main__":
    main()
