--クロシープ
function c50277355.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c50277355.lcheck)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,50277355)
	e1:SetCondition(c50277355.condition)
	e1:SetTarget(c50277355.target)
	e1:SetOperation(c50277355.activate)
	c:RegisterEffect(e1)
end
function c50277355.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c50277355.cfilter(c,lg)
	return lg:IsContains(c)
end
function c50277355.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50277355.condition(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c50277355.cfilter,1,nil,lg)
end
function c50277355.lkfilter(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function c50277355.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local b1=Duel.IsPlayerCanDraw(tp,2) and lg:IsExists(c50277355.lkfilter,1,nil,TYPE_RITUAL)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50277355.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and lg:IsExists(c50277355.lkfilter,1,nil,TYPE_FUSION)
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and lg:IsExists(c50277355.lkfilter,1,nil,TYPE_SYNCHRO)
	local b4=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and lg:IsExists(c50277355.lkfilter,1,nil,TYPE_XYZ)
	if chk==0 then return b1 or b2 or b3 or b4 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c50277355.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lg=e:GetHandler():GetLinkedGroup()
	local b1=Duel.IsPlayerCanDraw(tp,2) and lg:IsExists(c50277355.lkfilter,1,nil,TYPE_RITUAL)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c50277355.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and lg:IsExists(c50277355.lkfilter,1,nil,TYPE_FUSION)
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and lg:IsExists(c50277355.lkfilter,1,nil,TYPE_SYNCHRO)
	local b4=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and lg:IsExists(c50277355.lkfilter,1,nil,TYPE_XYZ)
	local res=0
	if b1 then
		res=Duel.Draw(tp,2,REASON_EFFECT)
		if res==2 then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)
		end
	end
	if b2 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50277355.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			res=Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if b3 then
		if res~=0 then Duel.BreakEffect() end
		local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc1=g2:GetFirst()
		while tc1 do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(700)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e1)
			res=res+1
			tc1=g2:GetNext()
		end
	end
	if b4 then
		if res~=0 then Duel.BreakEffect() end
		local g3=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc2=g3:GetFirst()
		while tc2 do
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-700)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e2)
			tc2=g3:GetNext()
		end
	end
end
