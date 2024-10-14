--リンクアップル
---@param c Card
function c7925734.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7925734,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,7925734)
	e1:SetCost(c7925734.spcost)
	e1:SetTarget(c7925734.sptg)
	e1:SetOperation(c7925734.spop)
	c:RegisterEffect(e1)
end
function c7925734.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c7925734.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c7925734.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7925734.rmfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function c7925734.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c7925734.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()==0 then return end
	Duel.ShuffleExtra(tp)
	local tc=g:RandomSelect(tp,1):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED)
		and c:IsRelateToEffect(e) then
		if tc:IsType(TYPE_LINK) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.BreakEffect()
			if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)~=0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
