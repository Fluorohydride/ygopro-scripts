--海晶乙女雪花
---@param c Card
function c80627281.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,80627281+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80627281.target)
	e1:SetOperation(c80627281.activate)
	c:RegisterEffect(e1)
end
function c80627281.spfilter1(c,e,tp)
	local lk=c:GetLink()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and c:IsPreviousSetCard(0x12b) and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
		and lk>0 and Duel.IsExistingMatchingCard(c80627281.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lk)
end
function c80627281.spfilter2(c,e,tp,lk)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_LINK) and c:GetLink()<lk
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c80627281.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c80627281.spfilter1(chkc,e,tp) end
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL)
		and eg:IsExists(c80627281.spfilter1,1,nil,e,tp) end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=eg:FilterSelect(tp,c80627281.spfilter1,1,1,nil,e,tp)
		Duel.SetTargetCard(g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80627281.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80627281.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLink())
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c80627281.immcon)
		e1:SetValue(c80627281.efilter)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CONTROL)
		tc:RegisterEffect(e1,true)
		tc:CompleteProcedure()
	end
end
function c80627281.immcon(e)
	return e:GetHandler():IsControler(e:GetOwnerPlayer())
end
function c80627281.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
