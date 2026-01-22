--A宝玉獣 ルビー・カーバンクル
function c83575471.initial_effect(c)
	aux.AddCodeList(c,12644061)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--self to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c83575471.tgcon)
	c:RegisterEffect(e1)
	--send replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c83575471.repcon)
	e2:SetOperation(c83575471.repop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,83575471)
	e3:SetCondition(c83575471.spcon)
	e3:SetTarget(c83575471.sptg)
	e3:SetOperation(c83575471.spop)
	c:RegisterEffect(e3)
end
function c83575471.tgcon(e)
	return not Duel.IsEnvironment(12644061)
end
function c83575471.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c83575471.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c83575471.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c83575471.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c83575471.filter(c,e,sp)
	return c:IsFaceup() and c:IsSetCard(0x5034) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c83575471.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ct<=0 then
				Duel.SpecialSummonComplete()
				return
			end
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
			local g=Duel.GetMatchingGroup(c83575471.filter,tp,LOCATION_SZONE,0,nil,e,tp)
			local gc=g:GetCount()
			if gc>0 and Duel.SelectYesNo(tp,aux.Stringid(83575471,0)) then
				Duel.DisableSelfDestroyCheck()
				Duel.SpecialSummonComplete()
				Duel.BreakEffect()
				if gc<=ct then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:Select(tp,ct,ct,nil)
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
				Duel.DisableSelfDestroyCheck(false)
			else
				Duel.SpecialSummonComplete()
			end
		else
			Duel.SpecialSummonComplete()
		end
	end
end
