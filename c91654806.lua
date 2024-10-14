--宇宙との交信
---@param c Card
function c91654806.initial_effect(c)
	aux.AddCodeList(c,77585513)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91654806,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,91654806)
	e1:SetCost(c91654806.spcost)
	e1:SetTarget(c91654806.sptg)
	e1:SetOperation(c91654806.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91654806,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,91654807)
	e2:SetCondition(c91654806.drcon)
	e2:SetTarget(c91654806.drtg)
	e2:SetOperation(c91654806.drop)
	c:RegisterEffect(e2)
end
function c91654806.tgfilter(c,tp)
	return c:GetOwner()~=tp and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c91654806.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c91654806.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c91654806.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c91654806.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c91654806.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==100 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c91654806.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c91654806.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c91654806.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c91654806.confilter(c)
	return c:IsFaceup() and c:IsCode(77585513)
end
function c91654806.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_RULE and Duel.IsExistingMatchingCard(c91654806.confilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c91654806.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c91654806.drop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then return end
	local opt=e:GetLabel()
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleHand(1-tp)
	local res=false
	local tc=g:GetFirst()
	while tc do
		if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
			res=true
		end
		tc=g:GetNext()
	end
	local c=e:GetHandler()
	if res and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
