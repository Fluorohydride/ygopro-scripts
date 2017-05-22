--ドラゴニック・タクティクス
function c72549351.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c72549351.cost)
	e1:SetTarget(c72549351.target)
	e1:SetOperation(c72549351.activate)
	c:RegisterEffect(e1)
end
function c72549351.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c72549351.rfilter(c,tp)
	return c:IsRace(RACE_DRAGON) and (c:IsControler(tp) or c:IsFaceup())
end
function c72549351.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c72549351.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:GetLevel()==8 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72549351.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(c72549351.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if chk==0 then
		if e:GetLabel()==0 then return ft>0
			and Duel.IsExistingMatchingCard(c72549351.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
		e:SetLabel(0)
		return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c72549351.mzfilter,ct,nil,tp))
	end
	if e:GetLabel()~=0 then
		local g=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			g=rg:Select(tp,2,2,nil)
		elseif ft==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			g=rg:FilterSelect(tp,c72549351.mzfilter,1,1,nil,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g2=rg:Select(tp,1,1,g:GetFirst())
			g:Merge(g2)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			g=rg:FilterSelect(tp,c72549351.mzfilter,2,2,nil,tp)
		end
		Duel.Release(g,REASON_COST)
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72549351.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72549351.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
