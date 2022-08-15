FROM archlinux as build

RUN pacman -Sy python base-devel git --noconfirm
RUN useradd -m bjorn
RUN usermod -aG wheel bjorn
RUN sed -i -E 's/^#\s+(%wheel\s+ALL=\(ALL:ALL\)\s+NOPASSWD:\s+ALL)/\1/' /etc/sudoers
RUN echo bjorn:docker | chpasswd

USER bjorn

COPY --chown=bjorn:bjorn ./ /home/bjorn/.dotfiles
WORKDIR /home/bjorn/.dotfiles

CMD ["sh", "-c", "echo docker | ./install"]


FROM build as debug
WORKDIR /tmp
RUN git clone https://aur.archlinux.org/yay.git \
    && cd yay && makepkg -si --noconfirm \
    && cd .. && rm -rf yay
