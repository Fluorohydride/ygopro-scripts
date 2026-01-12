--マテリアクトル・エクサガルド
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,99)
	c:EnableReviveLimit()
	--search or special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thorspcost)
	e1:SetTarget(s.thorsptg)
	e1:SetOperation(s.thorspop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.thorspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.thorspfilter(c,e,tp)
	if not c:IsSetCard(0x160) then return false end
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsAbleToHand()
	end
	return false
end
function s.thorsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thorspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function s.thorspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thorspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function s.cfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.cthfilter(c)
	return c:IsSetCard(0x160)
end
function s.thcheck(g)
	return g:IsExists(s.cthfilter,1,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return g:CheckSubGroup(s.thcheck,1,2) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	local g=c:GetOverlayGroup()
	if g:CheckSubGroup(s.thcheck,1)==false then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,s.thcheck,false,1,2)
	if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
		local sg=tg:Filter(Card.IsControler,nil,tp)
		if sg:GetCount()>0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		local og=tg:Filter(Card.IsControler,nil,1-tp)
		if og:GetCount()>0 then
			Duel.ConfirmCards(tp,og)
			Duel.ShuffleHand(1-tp)
		end
		if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_NORMAL)
			and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #rg>0 then
				Duel.HintSelection(rg)
				Duel.SendtoHand(rg,nil,REASON_EFFECT)
			end
		end
	end
end
