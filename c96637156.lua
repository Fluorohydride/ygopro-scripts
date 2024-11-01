--席取－六双丸
---@param c Card
function c96637156.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96637156,0))
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c96637156.movcon)
	e1:SetTarget(c96637156.movtg)
	e1:SetOperation(c96637156.movop)
	c:RegisterEffect(e1)
end
function c96637156.movcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c96637156.movtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c96637156.movop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetSequence()>=5 then return end
	local winflag=c:GetOverlayCount()<=6
	local dice=Duel.TossDice(tp,1)
	if dice<1 or dice>6 then return end
	local p=tp
	local seq=c:GetSequence()-dice
	while seq<0 do
		seq=seq+5
		p=1-p
	end
	local zone=1<<seq
	local tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
	if p~=tp and not c:IsControlerCanBeChanged(true)
		or Duel.GetMZoneCount(p,tc,tp,LOCATION_REASON_CONTROL,zone)<=0
		or tc and (not tc:IsCanOverlay(p) or tc:IsImmuneToEffect(e)) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if tc then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then Duel.Overlay(c,og) end
		Duel.Overlay(c,tc)
	end
	if p==tp then
		Duel.MoveSequence(c,seq)
	else
		Duel.GetControl(c,1-tp,0,0,zone)
	end
	local WIN_REASON_MUSOMARU=0x22
	if winflag and c:GetOverlayCount()>6 then Duel.Win(tp,WIN_REASON_MUSOMARU) end
end
