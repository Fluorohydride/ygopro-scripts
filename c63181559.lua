--トリックスター・ディフュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.csbtg)
	e2:SetOperation(s.csbop)
	c:RegisterEffect(e2)
end


function s.fusfilter(c)
	return c:IsSetCard(0xfb)
end

function s.filter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0xfb)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local fusion_effect=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		}
	})
	local res=fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then
		return res or Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil)
	end
	local op=0
	if res and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))+1
	elseif res then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+2
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
			fusfilter=s.fusfilter,
			pre_select_mat_location=LOCATION_GRAVE,
			mat_operation_code_map={
				{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
				{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
			}
		})
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
	end
end

function s.csbfilter(c)
	return c:IsSetCard(0xfb) and c:IsFaceup()
end

function s.csbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.csbfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.csbfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.csbfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function s.csbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetValue(s.lklimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function s.lklimit(e,c)
	return c~=e:GetHandler()
end
