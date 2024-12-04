--竜呼相打つ
function c14733538.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,14733538+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c14733538.target)
	e1:SetOperation(c14733538.activate)
	e1:SetValue(c14733538.zones)
	c:RegisterEffect(e1)
end
function c14733538.filter(c,e,tp,b1,setcode)
	return c:IsSetCard(setcode) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (b1 or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c14733538.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14733538.filter,tp,LOCATION_DECK,0,1,nil,e,tp,false,0xc7)
		and Duel.IsExistingMatchingCard(c14733538.filter,tp,LOCATION_DECK,0,1,nil,e,tp,false,0xda)
	if p0==p1 or sp then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c14733538.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return (b1 or b2)
		and Duel.IsExistingMatchingCard(c14733538.filter,tp,LOCATION_DECK,0,1,nil,e,tp,b1,0xc7)
		and Duel.IsExistingMatchingCard(c14733538.filter,tp,LOCATION_DECK,0,1,nil,e,tp,b1,0xda) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c14733538.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not b1 and not b2 then return end
	local g1=Duel.GetMatchingGroup(c14733538.filter,tp,LOCATION_DECK,0,nil,e,tp,b1,0xc7)
	local g2=Duel.GetMatchingGroup(c14733538.filter,tp,LOCATION_DECK,0,nil,e,tp,b1,0xda)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleDeck(tp)
	local cg=sg1:Select(1-tp,1,1,nil)
	local tc=cg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	if b1 and (not b2 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectOption(tp,1160,1152)==0) then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	sg1:RemoveCard(tc)
	Duel.SendtoExtraP(sg1,nil,REASON_EFFECT)
end
