--ふわんだりぃずと未知の風
function c55521751.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55521751,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c55521751.otcon)
	e1:SetTarget(c55521751.ottg)
	e1:SetOperation(c55521751.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--Send to Deck & Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55521751,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,55521751)
	e3:SetTarget(c55521751.drtg)
	e3:SetOperation(c55521751.drop)
	c:RegisterEffect(e3)
end
function c55521751.otfilter(c,e,tp)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and Duel.GetMZoneCount(tp,c)>0
end
function c55521751.otfilter2(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c55521751.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2
		and Duel.IsExistingMatchingCard(c55521751.otfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c55521751.otfilter2,tp,0,LOCATION_ONFIELD,1,nil,e)
end
function c55521751.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2
end
function c55521751.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c55521751.otfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c55521751.otfilter2,tp,0,LOCATION_ONFIELD,1,1,nil,e)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	c:SetMaterial(nil)
end
function c55521751.drfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAbleToDeck() and not c:IsPublic()
end
function c55521751.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c55521751.drfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c55521751.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c55521751.drfilter,p,LOCATION_HAND,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=aux.PlaceCardsOnDeckBottom(p,g)
		if ct==0 then return end
		Duel.BreakEffect()
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
