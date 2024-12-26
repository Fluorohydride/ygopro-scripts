--光の天穿バハルティヤ
---@param c Card
function c53318263.initial_effect(c)
	--tribute summon with 1 effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53318263,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c53318263.rlcon)
	e1:SetOperation(c53318263.rlop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53318263,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c53318263.sumcon)
	e3:SetTarget(c53318263.sumtg)
	e3:SetOperation(c53318263.sumop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53318263,2))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,53318263)
	e4:SetTarget(c53318263.thtg)
	e4:SetOperation(c53318263.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c53318263.thcon)
	c:RegisterEffect(e5)
end
function c53318263.rlfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function c53318263.rlcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c53318263.rlfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(6) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c53318263.rlop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c53318263.rlfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c53318263.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c53318263.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==1-tp and eg:IsExists(c53318263.cfilter,1,nil,1-tp) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c53318263.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c53318263.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
function c53318263.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c53318263.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=#hg
	local dg=Duel.GetDecktopGroup(1-tp,ct)
	if chk==0 then return ct>0 and dg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct
		and hg:FilterCount(Card.IsAbleToDeck,nil)==ct end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,dg,ct,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,hg,ct,0,0)
end
function c53318263.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	local ct=#hg
	local dg=Duel.GetDecktopGroup(p,ct)
	if ct>0 and dg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct and Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)==ct then
		Duel.BreakEffect()
		local og=Duel.GetOperatedGroup()
		if Duel.SendtoDeck(hg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			Duel.SendtoHand(og,p,REASON_EFFECT)
		end
	end
end
