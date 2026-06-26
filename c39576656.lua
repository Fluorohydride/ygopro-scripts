--キラーチューン・クラックル
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddMaterialCodeList(c,43904702)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,43904702),nil,nil,aux.Tuner(nil),1,99)
	c:EnableReviveLimit()
	--remove extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--double tuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(21142671)
	c:RegisterEffect(e3)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g>0 then
		Duel.ConfirmCards(tp,g,true)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
		local tc=sg:GetFirst()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local fid=c:GetFieldID()
			local og=Duel.GetOperatedGroup()
			local oc=og:GetFirst()
			if oc then
				oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,4))
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabel(fid)
				e1:SetLabelObject(oc)
				e1:SetCountLimit(1)
				e1:SetOperation(s.retop)
				Duel.RegisterEffect(e1,tp)
				local atk=oc:GetAttack()
				if c:IsRelateToChain() and c:IsFaceup() and atk>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_UPDATE_ATTACK)
					e2:SetValue(atk)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
					c:RegisterEffect(e2)
				end
			end
		end
		Duel.ShuffleExtra(1-tp)
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(id)==fid then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and aux.NecroValleyFilter()(c) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
		if #g>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_EXTRA),true)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:FilterSelect(tp,Card.IsAbleToRemove,2,2,nil)
			if #sg==2 then
				local fid=c:GetFieldID()
				if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
					local og=Duel.GetOperatedGroup()
					for oc in aux.Next(og) do
						oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,4))
					end
					og:KeepAlive()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabel(fid)
					e1:SetLabelObject(og)
					e1:SetCountLimit(1)
					e1:SetOperation(s.retop2)
					Duel.RegisterEffect(e1,tp)
				end
			end
			Duel.ShuffleExtra(1-tp)
		end
	end
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retop2(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local tg=e:GetLabelObject():Filter(s.retfilter,nil,fid)
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
