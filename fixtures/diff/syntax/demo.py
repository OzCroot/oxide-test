# Helpers for the cart demo.
def total(items, tax=0.0):
    """Return the sum of the items.

    Tax is added on top.
    """
    return sum(items) * (1 + tax)


class Cart:
    def __init__(self):
        self.items = []
        self.coupon = None  # applied at checkout
