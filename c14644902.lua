--幻想召喚師
---@param c Card
function c14644902.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14644902,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(c14644902.target)
	e1:SetOperation(c14644902.operation)
	c:RegisterEffect(e1)
end
function c14644902.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14644902.rfilter(c,e,tp)
	return not c:IsImmuneToEffect(e)
		and Duel.IsExistingMatchingCard(c14644902.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c14644902.filter(c,e,tp,mc)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c14644902.rfilter2(c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,c,TYPE_FUSION)>0
end
function c14644902.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.SelectReleaseGroupEx(tp,c14644902.rfilter,1,1,REASON_EFFECT,false,aux.ExceptThisCard(e),e,tp)
	if Duel.Release(rg,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c14644902.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			local fid=c:GetFieldID()
			sg:GetFirst():RegisterFlagEffect(14644902,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(sg:GetFirst())
			e1:SetCondition(c14644902.descon)
			e1:SetOperation(c14644902.desop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if #rg==0 then
		rg=Duel.SelectReleaseGroupEx(tp,c14644902.rfilter2,1,1,REASON_EFFECT,false,aux.ExceptThisCard(e),tp)
		if #rg>0 then
			Duel.Release(rg,REASON_EFFECT)
		end
	end
end
function c14644902.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(14644902)==e:GetLabel()
end
function c14644902.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
