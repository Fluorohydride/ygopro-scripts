--異解△審判
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recycle
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS})
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.atkcon)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
function s.tgfilter(c,e,tp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSummonPlayer(1-tp) and c:IsCanBeEffectTarget(e)
		and (chk or Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,c,ft))
end
function s.spfilter(c,e,tp,ec,ft)
	return c:IsFacedown() and c:IsSetCard(0x1ed) and c:IsAttribute(ec:GetAttribute()) and not c:IsAttribute(Duel.GetFlagEffectLabel(tp,id))
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.tgfilter(chkc,e,tp,false) end
	local g=eg:Filter(s.tgfilter,nil,e,tp,false)
	if chk==0 then return g:GetCount()>0 end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,tc,ft)
		if #g>0 then
			local sc=g:GetFirst()
			if sc then
				local att=sc:GetAttribute()
				local flag=ft>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				if sc:IsAbleToHand() and (not flag or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				elseif flag then
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				end
				local label=Duel.GetFlagEffectLabel(tp,id)
				if label then
					Duel.SetFlagEffectLabel(tp,id,label|att)
				else
					Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,att)
				end
			end
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x1ed)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(aux.TRUE,e:GetHandlerPlayer(),LOCATION_DECK,0,nil)>0 then return end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if not a:IsControler(tp) then a,d=d,a end
	local res=a:IsControler(tp) and a:IsFaceup() and a:IsSetCard(0x1ed) and d:IsControler(1-tp) and d:IsFaceup() and d:IsRelateToBattle() and d:GetAttack()>0
	if res then e:SetLabelObject(d) end
	return res
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetLabelObject()
	if chk==0 then return d end
	Duel.SetTargetCard(d)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetFirstTarget()
	if not (d:IsRelateToBattle() and d:IsFaceup() and d:IsControler(1-tp)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(0)
	d:RegisterEffect(e1)
end
